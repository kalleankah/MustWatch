//
//  TitleDetailView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleDetailView: View {
    @Environment(\.titleDetailsRepository) private var repository

    var name: String
    var type: String
    var year: String
    var imdbID: String

    @State var titleDetail: TitleDetail?

    var body: some View {
        VStack {
            Image(.poster1)
                .resizable()
                .scaledToFit()
                .padding()

            HStack(alignment: .lastTextBaseline) {
                Text(name)
                    .font(.headline)
                Text(year)
                    .font(.subheadline)
            }

            if let titleDetail {
                Text(titleDetail.plot)
            }
        }
        .task {
            do {
                titleDetail = try await repository.fetchTitle(
                    by: imdbID,
                    fullPlot: false
                )
            } catch {
                print("fail")
            }
        }
    }
}

#Preview {
    TitleDetailView(
        name: "Shrek",
        type: "movie",
        year: "2009",
        imdbID: "1"
    )
}
