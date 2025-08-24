//
//  TitlesRepository.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

import Foundation

protocol SearchTitlesRepository: Sendable {
    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesError) -> [Title]
}

private struct SearchRequest: Hashable {
    let searchTerm: String
    let type: TitleContentType?
    let year: Int?
}

actor SearchTitlesRepositoryLive: SearchTitlesRepository {
    private let api: TitlesApi

    private var cache: [SearchRequest: [Title]] = [:]

    init(api: TitlesApi = TitlesApiLive()) {
        self.api = api
    }

    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesError) -> [Title] {
        let request = SearchRequest(searchTerm: searchTerm, type: type, year: year)

        if let cachedData = cache[request] {
            return cachedData
        }

        let data = try await fetchTitlesFromNetwork(
            by: searchTerm,
            type: type,
            year: year
        )

        cache[request] = data

        return data
    }

    private func convertToApiModelIfNeeded(
        _ domainContentType: TitleContentType?
    ) throws(TitlesError) -> TitleApiContentType? {
        guard let domainContentType else {
            return nil
        }

        guard let type = TitleApiContentType(rawValue: domainContentType.rawValue) else {
            throw TitlesError.requestError
        }

        return type
    }

    private func fetchTitlesFromNetwork(
        by searchTerm: String,
        type domainContentType: TitleContentType?,
        year: Int?
    ) async throws(TitlesError) -> [Title] {
        let type = try convertToApiModelIfNeeded(domainContentType)

        let titlesResponse: SearchTitlesResponse

        do {
            titlesResponse = try await api.searchTitles(
                by: searchTerm,
                type: type,
                year: year
            )
        } catch {
            switch error {
            case .invalidURL, .requestFailed(_):
                throw .requestError
            case .parsingFailure:
                throw .responseError
            case .requestCancelled:
                throw .requestCancelled
            case .tooManyResults:
                throw .tooManyResults
            case .noResults:
                throw .noResults
            case .authenticationFailure:
                throw .authenticationFailure
            case .unknown(_):
                throw .responseError
            }
        }

        let titles = try parseTitles(from: titlesResponse)

        return titles
    }

    private func parseTitles(
        from titlesResponse: SearchTitlesResponse
    ) throws(TitlesError) -> [Title] {
        var titles: [Title] = []

        for responseModel in titlesResponse.titles {
            guard let parsedType = TitleContentType(string: responseModel.type) else {
                throw .parsingError
            }

            titles.append(
                Title(
                    name: responseModel.name,
                    year: responseModel.year,
                    type: parsedType,
                    imdbID: responseModel.imdbID
                )
            )
        }

        return titles
    }
}

extension TitleContentType {
    init?(string: String) {
        switch string {
        case "movie":
            self = .movie
        case "series":
            self = .series
        case "episode":
            self = .episode
        default:
            return nil
        }
    }
}

extension TitleContentType {
    init?(from type: TitleContentType?) {
        switch type {
        case .episode:
            self = .episode
        case .movie:
            self = .movie
        case .series:
            self = .series
        case nil:
            return nil
        }
    }
}
