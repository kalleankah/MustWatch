//
//  TitlesApiTests.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Testing
import Foundation
@testable import MustWatch

struct TitlesApiTests {
    let session: NetworkSessionMock
    let api: any TitlesApi

    init() {
        session = NetworkSessionMock()
        api = TitlesApiLive(session: session)
    }

    @Test("Parse a search response")
    func parseSearchTitleResponse() async throws {
        let data = JsonLoader.load("searchResponseSample")

        session.dataToReturn = data
        session.statusCodeToReturn = 200

        let result = try await api.searchTitles(by: "test", type: nil, year: nil)

        let expectedResult = SearchTitlesResponse(
            titles: [
                SearchTitlesResponse.Title(
                    name: "The Shawshank Redemption",
                    year: "1994",
                    imdbID: "tt0111161",
                    type: "movie",
                    poster: "https://www.example.com/"
                )
            ],
            totalResults: "1",
            response: "True"
        )

        #expect(result == expectedResult)
    }

    @Test("Parse a failed search response")
    func parseSearchTitleResponseError() async throws {
        let data = JsonLoader.load("searchResponseInvalidApiKey")

        let expectedResult = TitlesApiResponseError(
            response: "False",
            errorReason: .invalidApiKey
        )

        let result = try JSONDecoder().decode(TitlesApiResponseError.self, from: data)

        #expect(result == expectedResult)
    }
}
