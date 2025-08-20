//
//  TitlesApiMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

@testable import MustWatch

actor TitlesApiMock: TitlesApi {
    var dataToReturn: SearchTitlesResponse
    var numberOfCalls: Int = 0

    init(dataToReturn: SearchTitlesResponse) {
        self.dataToReturn = dataToReturn
    }

    func searchTitles(
        by searchTerm: String,
        type: TitleContentType?,
        year: Int?
    ) async throws(TitlesApiError) -> SearchTitlesResponse {
        numberOfCalls += 1
        return dataToReturn
    }
}
