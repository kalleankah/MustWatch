//
//  TitlesApiResponseError.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

struct TitlesApiResponseError: Decodable, Error, Equatable {
    let response: String
    let errorReason: ErrorReason

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case errorReason = "Error"
    }
}

extension TitlesApiResponseError {
    enum ErrorReason: Error, Decodable, Equatable {
        case tooManyResults
        case noResults
        case invalidApiKey
        case unknown(string: String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            switch string {
            case "Too many results.":
                self = .tooManyResults
            case "Movie not found!":
                self = .noResults
            case "Invalid API key!":
                self = .invalidApiKey
            default:
                self = .unknown(string: string)
            }
        }
    }
}
