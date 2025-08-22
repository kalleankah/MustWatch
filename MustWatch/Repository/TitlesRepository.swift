//
//  TitlesRepository.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

import Foundation

protocol TitlesRepository: Sendable {
    func searchTitles(
        by searchTerm: String,
        type: Title.ContentType?,
        year: Int?
    ) async throws(TitlesSearchError) -> [Title]
}

private struct SearchRequest: Hashable {
    let searchTerm: String
    let type: Title.ContentType?
    let year: Int?
}

actor TitlesRepositoryLive: TitlesRepository {
    private let api: TitlesApi

    private var cache: [SearchRequest: [Title]] = [:]

    init(api: TitlesApi = TitlesApiLive()) {
        self.api = api
    }

    func searchTitles(
        by searchTerm: String,
        type: Title.ContentType?,
        year: Int?
    ) async throws(TitlesSearchError) -> [Title] {
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

    private func fetchTitlesFromNetwork(
        by searchTerm: String,
        type: Title.ContentType?,
        year: Int?
    ) async throws(TitlesSearchError) -> [Title] {
        let type = TitleContentType(from: type)

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
    ) throws(TitlesSearchError) -> [Title] {
        var titles: [Title] = []

        for responseModel in titlesResponse.titles {
            guard let parsedType = Title.ContentType(string: responseModel.type) else {
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

extension Title.ContentType {
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
    init?(from type: Title.ContentType?) {
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
