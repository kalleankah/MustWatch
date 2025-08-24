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

    var additionalInformation: [(String, String)] {
        [
            ("Released", released),
            ("Runtime", runtime),
            ("Genre", genre),
            ("Director", director),
            ("Country", country),
            ("Language", language),
            ("Writer", writer)
        ]
    }

    var reviews: [(String, String)] {
        [
            ("Metascore", metascore),
            ("imdbRating", imdbRating),
            ("imdbVotes", imdbVotes)
        ]
    }

}

extension TitleDetail {
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

extension TitleDetail {
    static let sample = TitleDetail(
        title: "The Shawshank Redemption",
        year: "1994",
        rated: "R",
        released: "14 Oct 1994",
        runtime: "142 min",
        genre: "Drama",
        director: "Frank Darabont",
        writer: "Stephen King, Frank Darabont",
        actors: "Tim Robbins, Morgan Freeman, Bob Gunton",
        plot: "Chronicles the experiences of a formerly successful banker as a prisoner in the gloomy jailhouse of Shawshank after being found guilty of a crime he did not commit. The film portrays the man's unique way of dealing with his new, torturous life; along the way he befriends a number of fellow prisoners, most notably a wise long-term inmate named Red.",
        language: "English",
        country: "United States",
        awards: "Nominated for 7 Oscars. 21 wins & 42 nominations total",
        poster: "https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_SX300.jpg",
        ratings: [
            .init(source: "Internet Movie Database", value: "9.3/10"),
            .init(source: "Rotten Tomatoes", value: "89%"),
            .init(source: "Metacritic", value: "82/100")
        ],
        metascore: "82",
        imdbRating: "9.3",
        imdbVotes: "3,075,711",
        imdbID: "tt0111161",
        type: "movie",
        dvd: "N/A",
        boxOffice: "$28,767,189",
        production: "N/A"
    )
}
