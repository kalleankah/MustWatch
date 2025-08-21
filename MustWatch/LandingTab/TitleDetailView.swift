//
//  TitleDetailView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleDetailView: View {
    var name: String
    var type: String
    var year: String

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
        }
    }
}

#Preview {
    TitleDetailView(
        name: "Shrek",
        type: "movie",
        year: "2009"
    )
}
