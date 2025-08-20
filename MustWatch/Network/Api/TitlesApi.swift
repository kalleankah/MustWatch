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
}

struct TitlesApiLive: TitlesApi {

    private let baseURL = "https://www.omdbapi.com/"
    private let apiKey = "8f808fc"
    private let session: any NetworkSession

    init(session: any NetworkSession = URLSession.shared) {
        self.session = session
    }

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
            throw TitlesApiError.requestFailed(underlyingError: error)
        }

        do {
            return try parseResponse(
                SearchTitlesResponse.self,
                from: data,
                response: response
            )
        } catch {
            throw TitlesApiError.decodingError(underlyingError: error)
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

        do {
            return try parseResponse(
                TitleDetailResponse.self,
                from: data,
                response: response
            )
        } catch {
            throw TitlesApiError.decodingError(underlyingError: error)
        }
    }

    private func parseResponse<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        response: URLResponse
    ) throws(TitlesApiError) -> T {
        let decoder = JSONDecoder()

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            do {
                let failureResponse = try decoder.decode(TitlesApiResponseError.self, from: data)
                throw TitlesApiError.parsingFailure(message: failureResponse.error)
            } catch {
                throw TitlesApiError.decodingError(underlyingError: error)
            }
        }

        do {
            let successfulResponse = try decoder.decode(T.self, from: data)
            return successfulResponse
        } catch {
            throw TitlesApiError.decodingError(underlyingError: error)
        }
    }
}
