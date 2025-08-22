//
//  NetworkSessionMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Foundation
@testable import MustWatch

class NetworkSessionMock: NetworkSession, @unchecked Sendable {
    var statusCodeToReturn: Int = 200
    var dataToReturn: Data? = nil
    var errorToThrow: Error? = nil
    var requestedURL: URL? = nil

    func data(from url: URL) async throws -> (Data, URLResponse) {
        requestedURL = url
        
        if let error = errorToThrow {
            throw error
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCodeToReturn,
            httpVersion: nil,
            headerFields: nil
        )!

        return (dataToReturn ?? Data(), response)
    }
}
