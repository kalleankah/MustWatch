//
//  TitleModel.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftData

@Model
class TitleModel {
    enum ContentType: String, Codable {
        case movie
        case series
        case episode
    }

    var name: String
    var year: String
    var type: ContentType
    @Attribute(.unique) var imdbID: String

    init(name: String, year: String, type: ContentType, imdbID: String) {
        self.name = name
        self.year = year
        self.type = type
        self.imdbID = imdbID
    }
}

extension TitleModel.ContentType {
    init(from type: Title.ContentType) {
        self = switch type {
        case .movie:
            .movie
        case .series:
            .series
        case .episode:
            .episode
        }
    }
}

extension TitleModel {
    convenience init(from title: Title) {
        self.init(
            name: title.name,
            year: title.year,
            type: .init(from: title.type),
            imdbID: title.imdbID
        )
    }
}
