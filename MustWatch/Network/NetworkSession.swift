//
//  NetworkSession.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Foundation

protocol NetworkSession: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
