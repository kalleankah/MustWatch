//
//  TitlesRepositoryMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

struct TitleDetailsRepositoryMock: TitleDetailsRepository {
    var dataToReturn = TitleDetail.sampleData
    var error: TitlesError?

    func fetchTitle(
        by imdbID: String,
        fullPlot: Bool
    ) async throws(TitlesError) -> TitleDetail {
        if let error {
            throw error
        }

        return dataToReturn
    }
}

private extension TitleDetail {
    static let sampleData: TitleDetail = TitleDetail(
        title: "Frozen",
        year: "2013",
        rated: "rated",
        released: "released",
        runtime: "runtime",
        genre: "genre",
        director: "director",
        writer: "writer",
        actors: "actors",
        plot: "plot",
        language: "language",
        country: "country",
        awards: "awards",
        poster: "poster",
        ratings: [
            .init(source: "Some source", value: "10/10")
        ],
        metascore: "metascore",
        imdbRating: "imdbRating",
        imdbVotes: "imdbVotes",
        imdbID: "imdbID",
        type: .movie,
        dvd: "dvd",
        boxOffice: "boxOffice",
        production: "production"
    )
}
