//
//  NetworkSessionMock.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Foundation
@testable import MustWatch

class NetworkSessionMock: NetworkSession, @unchecked Sendable {
    var dataToReturn: Data?
    var errorToThrow: Error?
    var statusCodeToReturn: Int?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = errorToThrow {
            throw error
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCodeToReturn!,
            httpVersion: nil,
            headerFields: nil
        )!

        return (dataToReturn ?? Data(), response)
    }
}
