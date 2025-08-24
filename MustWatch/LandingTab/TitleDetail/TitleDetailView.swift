//
//  TitleDetailView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.titleDetailsRepository) private var repository

    @Bindable var titleDetailModel: TitleDetailModel

    @State private var titleDetail: TitleDetail?
    @State private var isRatingTitle = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                poster

                title

                if let rating = titleDetailModel.rating {
                    userRating(rating)
                }

                cast

                reviews

                additionalInformation

                plot

                awards
            }
            .animation(.default, value: titleDetailModel.rating)
            .padding(26)
            .task {
                await fetchDetails()
            }
        }
        .contentMargins(.bottom, 64)
        .toolbar {
            if titleDetailModel.rating != nil {
                ToolbarItem {
                    Button("Remove") {
                        titleDetailModel.rating = nil
                        modelContext.delete(titleDetailModel)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if titleDetailModel.rating == nil {
                Button("Rate this \(titleDetailModel.type.rawValue)") {
                    rate()
                }
                .buttonStyle(.primary)
                .padding(.horizontal, 32)
                .padding(.vertical)
            }
        }
        .sheet(isPresented: $isRatingTitle) {
            if titleDetailModel.rating == nil {
                modelContext.delete(titleDetailModel)
            }
        } content: {
            RateTitleView(titleModel: titleDetailModel)
                .presentationDetents([.height(150)])
        }
    }

    var title: some View {
        Text(titleDetailModel.name)
            .font(.largeTitle)
            .multilineTextAlignment(.center)

    }

    var poster: some View {
        Image(.poster3)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 600)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
    }

    func userRating(_ rating: Int) -> some View {
        HStack {
            ForEach(1...10, id: \.self) { starNumber in
                let isSelected = starNumber <= rating

                Button {
                    updateRating(starNumber)
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(isSelected ? .yellow : .primary)
                        .symbolVariant(isSelected ? .fill : .none)
                }
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    var cast: some View {
        if let titleDetail {
            TitleDetailSection(
                header: "Cast",
                content: titleDetail.actors
            )
        }
    }

    @ViewBuilder
    var additionalInformation: some View {
        if let titleDetail {
            TitleBasicSection(
                header: "Details",
                content: titleDetail.additionalInformation
            )
        }
    }

    @ViewBuilder
    var plot: some View {
        if let titleDetail {
            TitleDetailSection(
                header: "Plot summary",
                content: titleDetail.plot
            )
        }
    }

    @ViewBuilder
    var awards: some View {
        if let titleDetail {
            TitleDetailSection(
                header: "Awards",
                content: titleDetail.awards
            )
        }
    }

    @ViewBuilder
    var reviews: some View {
        if let titleDetail {
            TitleBasicSection(
                header: "Reviews",
                content: titleDetail.reviews
            )
        }
    }

    private func fetchDetails() async {
        do {
            titleDetail = try await repository.fetchTitle(
                by: titleDetailModel.imdbID,
                fullPlot: false
            )
        } catch {
            print("fail")
        }
    }

    private func rate() {
        modelContext.insert(titleDetailModel)
        isRatingTitle = true
    }

    private func updateRating(_ newRating: Int) {
        titleDetailModel.rating = newRating
    }
}

#Preview {
    @Previewable @State var titleDetailModel = TitleDetailModel(
        name: "The shawshank redemption",
        year: "1994",
        type: .movie,
        imdbID: "1"
    )

    TitleDetailView(titleDetailModel: titleDetailModel)
        .environment( \.titleDetailsRepository, TitleDetailsRepositoryMock(
            dataToReturn: TitleDetail.sample
        ))
        .modelContainer(.previewContainerTitles)
}
