//
//  TitlesApiMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

@testable import MustWatch

class TitlesApiMock: TitlesApi, @unchecked Sendable {
    var dataToReturnSearchTitles: SearchTitlesResponse?
    var numberOfCallsSearchTitles: Int = 0

    var dataToReturnFetchTitle: TitleDetailResponse?
    var numberOfCallsFetchTitle: Int = 0

    init() {}

    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesApiError) -> SearchTitlesResponse {
        numberOfCallsSearchTitles += 1
        return dataToReturnSearchTitles ?? .empty
    }

    func fetchTitle(
        by imdbID: String
    ) async throws(TitlesApiError) -> TitleDetailResponse {
        numberOfCallsFetchTitle += 1
        return dataToReturnFetchTitle ?? .empty
    }
}


// MARK: Mock data

private extension SearchTitlesResponse {
    static let empty = SearchTitlesResponse(
        titles: [],
        totalResults: "",
        response: ""
    )
}

private extension TitleDetailResponse {
    static let empty = TitleDetailResponse(
        title: "",
        year: "",
        rated: "",
        released: "",
        runtime: "",
        genre: "",
        director: "",
        writer: "",
        actors: "",
        plot: "",
        language: "",
        country: "",
        awards: "",
        poster: "",
        ratings: [],
        metascore: "",
        imdbRating: "",
        imdbVotes: "",
        imdbID: "",
        type: "",
        dvd: nil,
        boxOffice: nil,
        production: nil,
        website: nil,
        response: ""
    )
}
