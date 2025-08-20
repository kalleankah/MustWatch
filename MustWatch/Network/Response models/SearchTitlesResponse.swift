//
//  ResponseModels.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-19.
//

struct SearchTitlesResponse: Decodable, Equatable {
    let titles: [Title]
    let totalResults: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case titles = "Search"
        case totalResults
        case response = "Response"
    }
}

extension SearchTitlesResponse {
    struct Title: Decodable, Hashable {
        let name: String
        let year: String
        let imdbID: String
        let type: String
        let poster: String

        enum CodingKeys: String, CodingKey {
            case name = "Title"
            case year = "Year"
            case imdbID
            case type = "Type"
            case poster = "Poster"
        }
    }
}

struct TitlesApiResponseError: Decodable, Error, Equatable {
    let response: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
