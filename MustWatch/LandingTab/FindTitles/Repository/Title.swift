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

extension Title {
    static let sampleData: [Title] = [
        Title(
            name: "name 1",
            year: "year 1",
            type: .episode,
            imdbID: "imdbID 1"
        ),
        Title(
            name: "name 2",
            year: "year 2",
            type: .movie,
            imdbID: "imdbID 2"
        )
    ]
}
