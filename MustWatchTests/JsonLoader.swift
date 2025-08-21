//
//  JsonLoader.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import Foundation

class JsonLoader {
    static func load(_ filename: String) -> Data {
        let bundle = Bundle(for: JsonLoader.self)
        let url = bundle.url(forResource: filename, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
