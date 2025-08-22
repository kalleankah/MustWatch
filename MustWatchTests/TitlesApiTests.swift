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
    let mockSession: NetworkSessionMock
    let api: any TitlesApi
    static let mockApiKey = "mockApiKey"

    init() {
        mockSession = NetworkSessionMock()
        api = TitlesApiLive(apiKey: Self.mockApiKey, session: mockSession)
    }

    @Test("Search Titles Construct URL", arguments: [
        ("Test Movie", TitleContentType.movie, 1234, "https://www.omdbapi.com/?apikey=\(mockApiKey)&s=Test%20Movie&type=movie&y=1234"),
        ("Test Series", TitleContentType.series, nil, "https://www.omdbapi.com/?apikey=\(mockApiKey)&s=Test%20Series&type=series"),
        ("Test", nil, nil, "https://www.omdbapi.com/?apikey=\(mockApiKey)&s=Test")
    ])
    func constructURLSearchTitles(
        searchText: String,
        type: TitleContentType?,
        year: Int?,
        expectedURL: String
    ) async throws {
        _ = try? await api.searchTitles(by: searchText, type: type, year: year)
        #expect(mockSession.requestedURL?.absoluteString == expectedURL)
    }

    @Test("Title Details Construct URL", arguments: [
        ("1234", true, "https://www.omdbapi.com/?apikey=\(mockApiKey)&i=1234&plot=full"),
        ("5678", false, "https://www.omdbapi.com/?apikey=\(mockApiKey)&i=5678")
    ])
    func constructURLTitleDetails(
        imdbID: String,
        fullPlot: Bool,
        expectedURL: String
    ) async throws {
        _ = try? await api.fetchTitle(by: imdbID, fullPlot: fullPlot)
        #expect(mockSession.requestedURL?.absoluteString == expectedURL)
    }

    @Test("Parse a search response")
    func parseSearchTitleResponse() async throws {
        let data = JsonLoader.load("searchResponseSample")

        mockSession.dataToReturn = data
        mockSession.statusCodeToReturn = 200

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
