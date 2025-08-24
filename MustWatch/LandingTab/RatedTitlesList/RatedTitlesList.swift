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
    @Query private var titles: [TitleDetailModel]

    var body: some View {
        NavigationStack {
            List(titles) { title in
                NavigationLink(value: title) {
                    TitleCellView(
                        name: title.name,
                        type: title.type.rawValue,
                        year: title.year
                    )
                }
            }
            .navigationDestination(for: TitleDetailModel.self) { title in
                @Bindable var title = title
                TitleDetailView(titleDetailModel: title)
            }
        }
    }
}

#Preview {
    RatedTitlesList()
        .modelContainer(.previewContainerTitles)
}
