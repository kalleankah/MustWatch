//
//  awpdoawp.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-23.
//

import SwiftData

extension ModelContainer {
    @MainActor
    static let previewContainerTitles: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: TitleDetailModel.self,
            configurations: config
        )

        let titles = [
            TitleDetailModel(
                name: "Shrek",
                year: "2000",
                type: .movie,
                imdbID: "1"
            ),
            TitleDetailModel(
                name: "Hercules",
                year: "1997",
                type: .movie,
                imdbID: "2"
            )
        ]

        for title in titles {
            container.mainContext.insert(title)
        }

        return container
    }()
}
