//
//  SearchView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct SearchView: View {
    let titles: [Title] = [
        .init(name: "Test 1", year: "1994", type: .movie, imdbID: "1"),
        .init(name: "Test 2", year: "2002", type: .movie, imdbID: "2")
    ]

    var body: some View {
        List(titles, id: \.imdbID) { title in
            TitleListItem(
                name: title.name,
                type: title.type.rawValue,
                year: title.year
            )
        }
    }
}

#Preview {
    SearchView()
}
