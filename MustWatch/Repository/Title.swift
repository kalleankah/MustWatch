//
//  Title.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-20.
//

struct Title: Hashable {
    enum ContentType: String, CaseIterable {
        case movie
        case series
        case episode
    }

    let name: String
    let year: String
    let type: ContentType
    let imdbID: String
}
