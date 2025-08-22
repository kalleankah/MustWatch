//
//  Untitled.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

import Foundation

enum TitlesApiError: Error {
    case invalidURL
    case requestFailed(underlyingError: Error)
    case requestCancelled
    case tooManyResults
    case decodingError(underlyingError: Error)
    case parsingFailure(message: String)
}
