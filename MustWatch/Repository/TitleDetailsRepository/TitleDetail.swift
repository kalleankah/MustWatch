//
//  Title.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

struct TitleDetail: Hashable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String?
    let boxOffice: String?
    let production: String?

    enum ContentType: String {
        case movie
        case series
        case episode
    }

    struct Rating: Hashable {
        let source: String
        let value: String
    }
}

extension TitleDetail {
    init(from response: TitleDetailResponse) {
        self.init(
            title: response.title,
            year: response.year,
            rated: response.rated,
            released: response.released,
            runtime: response.runtime,
            genre: response.genre,
            director: response.director,
            writer: response.writer,
            actors: response.actors,
            plot: response.plot,
            language: response.language,
            country: response.country,
            awards: response.awards,
            poster: response.poster,
            ratings: response.ratings.map(TitleDetail.Rating.init),
            metascore: response.metascore,
            imdbRating: response.imdbRating,
            imdbVotes: response.imdbVotes,
            imdbID: response.imdbID,
            type: response.type,
            dvd: response.dvd,
            boxOffice: response.boxOffice,
            production: response.production
        )
    }
}

extension TitleDetail.Rating {
    init(from response: TitleDetailResponse.Rating) {
        self.source = response.source
        self.value = response.value
    }
}
