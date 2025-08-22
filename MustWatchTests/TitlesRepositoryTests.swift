//
//  MustWatchTests.swift
//  MustWatchTests
//
//  Created by Karl Eknefelt on 2025-08-19.
//

import Testing
@testable import MustWatch


struct TitlesRepositoryTests {
    let apiResponseData = SearchTitlesResponse.sample
    let api: TitlesApiMock
    let repository: any TitlesRepository

    init() {
        api = TitlesApiMock()
        repository = TitlesRepositoryLive(api: api)
    }

    // Given empty cache, when calling searchTitles, should make a new request
    @Test("On cache miss, calls API and saves new data")
    func searchTitlesCacheMiss() async throws {
        let searchTerm = "test"
        let type = Title.ContentType.episode
        let year = 2000

        try #require(await api.numberOfCallsSearchTitles == 0)

        _ = try await repository.searchTitles(
            by: searchTerm,
            type: type,
            year: year
        )

        #expect(await api.numberOfCallsSearchTitles == 1)
    }

    @Test("Parse API response to data model")
    func searchTitlesParse() async throws {
        api.dataToReturnSearchTitles = SearchTitlesResponse(
            titles: [
                .init(
                    name: "Test",
                    year: "2000",
                    imdbID: "123",
                    type: "movie",
                    poster: ""
                )
            ],
            totalResults: "",
            response: ""
        )

        let expectedResult = Title(
            name: "Test",
            year: "2000",
            type: .movie,
            imdbID: "123"
        )

        let result = try await repository.searchTitles(by: "", type: nil, year: 0)

        #expect(result.first == expectedResult)
    }

    @Test("On cache hit, return cached data without making a new request")
    func searchTitlesCacheHit() async throws {
        let searchTerm = "test"
        let type = Title.ContentType.episode
        let year = 2000

        let firstResult = try await repository.searchTitles(
            by: searchTerm,
            type: type,
            year: year
        )

        #expect(await api.numberOfCallsSearchTitles == 1)

        let secondResult = try await repository.searchTitles(
            by: searchTerm,
            type: type,
            year: year
        )

        #expect(await api.numberOfCallsSearchTitles == 1)
        #expect(firstResult == secondResult)
    }
}

extension SearchTitlesResponse {
    static let sample = SearchTitlesResponse(
        titles: [
            .init(
                name: "Test",
                year: "2000",
                imdbID: "123",
                type: "movie",
                poster: "Test"
            )
        ],
        totalResults: "1",
        response: "Response"
    )
}
