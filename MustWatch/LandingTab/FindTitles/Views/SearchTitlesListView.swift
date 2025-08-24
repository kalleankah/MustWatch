//
//  SearchResultListView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftUI
import SwiftData

struct SearchTitlesListView: View {
    @Environment(\.modelContext) private var modelContext
    var titles: [Title]
    @Binding var selectedTitle: Title?

    var body: some View {
        List(titles, id: \.imdbID) { title in
            NavigationLink(value: title) {
                TitleCellView(
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
            let imdbID = title.imdbID

            let fetchDescriptor = FetchDescriptor<TitleDetailModel>(
                predicate: #Predicate { $0.imdbID == imdbID }
            )

            if let localTitle = try? modelContext.fetch(fetchDescriptor).first {
                TitleDetailView(titleDetailModel: localTitle)
            } else {
                let titleDetailModel = TitleDetailModel(
                    name: title.name,
                    year: title.year,
                    type: title.type,
                    imdbID: title.imdbID
                )

                TitleDetailView(titleDetailModel: titleDetailModel)
            }
        }
    }
}
