//
//  TitleDetailView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleDetailView: View {
    var api: TitlesApi = TitlesApiLive() // TODO: Replace with repository

    var name: String
    var type: String
    var year: String
    var imdbID: String

    @State var titleDetailResponse: TitleDetailResponse? // TODO: Replace with domain model

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

            if let titleDetailResponse {
                Text(titleDetailResponse.plot)
            }
        }
        .task {
            do {
                titleDetailResponse = try await api.fetchTitle(by: imdbID)
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
