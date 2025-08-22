//
//  TitlesRepository.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

import Foundation

protocol TitleDetailsRepository: Sendable {
    func fetchTitle(
        by imdbID: String,
        fullPlot: Bool
    ) async throws(TitlesError) -> TitleDetail
}

actor TitleDetailsRepositoryLive: TitleDetailsRepository {
    private let api: TitlesApi

    private var cache: [String: TitleDetail] = [:]

    init(api: TitlesApi = TitlesApiLive()) {
        self.api = api
    }

    func fetchTitle(
        by imdbID: String,
        fullPlot: Bool
    ) async throws(TitlesError) -> TitleDetail {
        if let cachedData = cache[imdbID] {
            return cachedData
        }

        let data = try await fetchTitleFromNetwork(
            by: imdbID,
            fullPlot: fullPlot
        )

        cache[imdbID] = data

        return data
    }

    private func fetchTitleFromNetwork(
        by imdbID: String,
        fullPlot: Bool
    ) async throws(TitlesError) -> TitleDetail {

        let titleDetailResponse: TitleDetailResponse
        do {
            titleDetailResponse = try await api.fetchTitle(
                by: imdbID,
                fullPlot: fullPlot
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

        return TitleDetail(from: titleDetailResponse)
    }
}
