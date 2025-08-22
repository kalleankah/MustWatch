//
//  Untitled.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Foundation

enum TitlesSearchError: LocalizedError {
    case requestError
    case responseError
    case parsingError
    case requestCancelled
    case tooManyResults
    case noResults
    case authenticationFailure

    var errorDescription: String? {
        switch self {
        case .requestError:
            "Could not reach server"
        case .responseError:
            "The server responded with an error"
        case .parsingError:
            "The server responded with currpt data"
        case .tooManyResults:
            "Too many matches, refine the search term"
        case .requestCancelled:
            nil
        case .noResults:
            "No results found"
        case .authenticationFailure:
            "Authentication failure"
        }
    }
}
