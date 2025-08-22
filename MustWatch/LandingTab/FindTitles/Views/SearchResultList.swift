//
//  SearchResultList.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftUI

struct SearchResultList: View {
    var titles: [Title]
    @Binding var selectedTitle: Title?

    var body: some View {
        List(titles, id: \.imdbID) { title in
            NavigationLink(value: title) {
                TitleListItem(
                    name: title.name,
                    type: title.type.rawValue,
                    year: title.year
                )
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button("Rate") {
                    selectedTitle = title
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Title.self) { title in
            TitleDetailView(
                name: title.name,
                type: title.type.rawValue,
                year: title.year
            )
        }
    }
}
