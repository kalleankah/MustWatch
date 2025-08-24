//
//  TitleModel.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftData

@Model
class TitleDetailModel {
    var name: String
    var year: String
    var type: TitleContentType
    var rating: Int?
    @Attribute(.unique) var imdbID: String

    init(
        name: String,
        year: String,
        type: TitleContentType,
        rating: Int? = nil,
        imdbID: String
    ) {
        self.name = name
        self.year = year
        self.type = type
        self.rating = rating
        self.imdbID = imdbID
    }
}

extension TitleDetailModel {
    convenience init(from title: Title) {
        self.init(
            name: title.name,
            year: title.year,
            type: title.type,
            imdbID: title.imdbID
        )
    }

    convenience init(from titleDetail: TitleDetail) {
        self.init(
            name: titleDetail.title,
            year: titleDetail.year,
            type: titleDetail.type,
            imdbID: titleDetail.imdbID
        )
    }
}
