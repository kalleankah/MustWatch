//
//  RateTitleView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-24.
//

import SwiftUI
import SwiftData

struct RateTitleView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var titleModel: TitleDetailModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    ForEach(1...10, id: \.self) { starNumber in
                        let isSelected = starNumber <= titleModel.rating ?? 0

                        Button {
                            updateRating(starNumber)
                        } label: {
                            Image(systemName: "star")
                                .foregroundStyle(isSelected ? .yellow : .primary)
                                .symbolVariant(isSelected ? .fill : .none)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
    }

    func updateRating(_ newRating: Int) {
        titleModel.rating = newRating
        dismiss()
    }
}

#Preview {
    @Previewable @State var model = TitleDetailModel(
        name: "Shrek",
        year: "2009",
        type: .movie,
        rating: nil,
        imdbID: "1"
    )

    RateTitleView(titleModel: model)
}
