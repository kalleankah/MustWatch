//
//  MyFavorites.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI
import SwiftData

struct RatedTitlesList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var titles: [TitleModel]

    var body: some View {
        NavigationStack {
            List(titles) { title in
                NavigationLink(value: title) {
                    TitleListItemView(
                        name: title.name,
                        type: title.type.rawValue,
                        year: title.year
                    )
                }
            }
            .navigationDestination(for: TitleModel.self) { title in
                TitleDetailView(
                    name: title.name,
                    type: title.type.rawValue,
                    year: title.year
                )
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: TitleModel.self,
        configurations: config
    )

    let titles = [
        TitleModel(
            name: "Shrek",
            year: "2000",
            type: .movie,
            imdbID: "1"
        ),
        TitleModel(
            name: "Hercules",
            year: "1997",
            type: .movie,
            imdbID: "2"
        )
    ]

    for title in titles {
        container.mainContext.insert(title)
    }

    return RatedTitlesList()
        .modelContainer(container)
}
