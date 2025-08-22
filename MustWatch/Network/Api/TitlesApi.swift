//
//  Api.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-19.
//

import Foundation

enum TitleContentType: String, CaseIterable {
    case movie
    case series
    case episode
}

protocol TitlesApi: Sendable {
    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesApiError) -> SearchTitlesResponse

    func fetchTitle(by imdbID: String) async throws(TitlesApiError) -> TitleDetailResponse
}

struct TitlesApiLive: TitlesApi {

    private let apiKey: String
    private let baseURL = "https://www.omdbapi.com/"
    private let session: any NetworkSession

    init(
        apiKey: String = "8f808fc",
        session: any NetworkSession = URLSession.shared
    ) {
        self.apiKey = apiKey
        self.session = session
    }

    // MARK: Protocol conformances

    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesApiError) -> SearchTitlesResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw TitlesApiError.invalidURL
        }

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: searchTerm)
        ]

        if let type {
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
        }

        if let year {
            queryItems.append(URLQueryItem(name: "y", value: String(year)))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw TitlesApiError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            if (error as? URLError)?.code == .cancelled {
                throw TitlesApiError.requestCancelled
            }

            throw TitlesApiError.requestFailed(underlyingError: error)
        }

        let result: Result<SearchTitlesResponse, TitlesApiResponseError.ErrorReason>

        do {
            result = try parseResponse(
                SearchTitlesResponse.self,
                from: data,
                response: response
            )
        } catch {
            throw TitlesApiError.parsingFailure
        }

        switch result {
        case .success(let response):
            return response
        case .failure(let response):
            throw parseFailure(response)
        }
    }

    func fetchTitle(by imdbID: String) async throws(TitlesApiError) -> TitleDetailResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw TitlesApiError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "i", value: imdbID)
        ]

        guard let url = urlComponents.url else {
            throw TitlesApiError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw TitlesApiError.requestFailed(underlyingError: error)
        }

        let result: Result<TitleDetailResponse, TitlesApiResponseError.ErrorReason>

        do {
            result = try parseResponse(
                TitleDetailResponse.self,
                from: data,
                response: response
            )
        } catch {
            throw TitlesApiError.parsingFailure
        }

        switch result {
        case .success(let response):
            return response
        case .failure(let response):
            throw parseFailure(response)
        }
    }

    // MARK: Private functions

    private func parseResponse<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        response: URLResponse
    ) throws -> Result<T, TitlesApiResponseError.ErrorReason> {
        let decoder = JSONDecoder()

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            let failureResponse = try decoder.decode(TitlesApiResponseError.self, from: data)

            return .failure(failureResponse.errorReason)
        }

        let successfulResponse = try decoder.decode(T.self, from: data)
        return .success(successfulResponse)
    }

    private func parseFailure(_ failure: TitlesApiResponseError.ErrorReason) -> TitlesApiError {
        switch failure {
        case .tooManyResults:
            return .tooManyResults
        case .noResults:
            return .noResults
        case .invalidApiKey:
            return .authenticationFailure
        case .unknown(let message):
            return .unknown(message: message)
        }
    }
}
