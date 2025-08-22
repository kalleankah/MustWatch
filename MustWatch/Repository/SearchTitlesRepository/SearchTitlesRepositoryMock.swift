//
//  TitlesRepositoryMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

struct SearchTitlesRepositoryMock: SearchTitlesRepository {
    var dataToReturn = Title.sampleData
    var error: TitlesError?

    func searchTitles(
        by searchTerm: String,
        type: Title.ContentType?,
        year: Int?
    ) async throws(TitlesError) -> [Title] {
        if let error {
            throw error
        }

        return dataToReturn
    }
}

private extension Title {
    static let sampleData: [Title] = [
        Title(
            name: "name 1",
            year: "year 1",
            type: .episode,
            imdbID: "imdbID 1"
        ),
        Title(
            name: "name 2",
            year: "year 2",
            type: .movie,
            imdbID: "imdbID 2"
        )
    ]
}
