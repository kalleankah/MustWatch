//
//  MetaResponse.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-23.
//

struct MetaResponse: Decodable {
    let response: String

    var isSuccessful: Bool {
        response == "True"
    }

    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }
}
