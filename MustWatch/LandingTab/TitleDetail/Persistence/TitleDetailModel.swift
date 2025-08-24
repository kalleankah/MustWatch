//
//  TitleModel.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftData

@Model
class TitleDetailModel {
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

extension TitleDetailModel.ContentType {
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

    init(from type: TitleDetail.ContentType) {
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

extension TitleDetailModel {
    convenience init(from title: Title) {
        self.init(
            name: title.name,
            year: title.year,
            type: .init(from: title.type),
            imdbID: title.imdbID
        )
    }

    convenience init(from titleDetail: TitleDetail) {
        self.init(
            name: titleDetail.title,
            year: titleDetail.year,
            type: ContentType(from: titleDetail.type),
            imdbID: titleDetail.imdbID
        )
    }
}
