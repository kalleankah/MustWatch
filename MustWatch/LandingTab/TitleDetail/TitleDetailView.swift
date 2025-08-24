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

    var name: String
    var type: String
    var year: String
    var imdbID: String

    @State private var titleDetail: TitleDetail?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                poster

                title

                cast

                reviews

                additionalInformation

                plot

                awards
            }
            .padding(26)
            .task {
                await fetchDetails()
            }
        }
        .contentMargins(.bottom, 64)
        .overlay(alignment: .bottom) {
            Button("Rate this \(type)") {
                rateAndSave()
            }
            .buttonStyle(.primary)
            .padding(.horizontal, 32)
        }
    }

    var title: some View {
        Text(name)
            .font(.largeTitle)
            .multilineTextAlignment(.center)

    }

    var poster: some View {
        Image([ImageResource.poster1, ImageResource.poster2, ImageResource.poster3].randomElement()!)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 600)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
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
                by: imdbID,
                fullPlot: false
            )
        } catch {
            print("fail")
        }
    }

    private func rateAndSave() {
        if let type = TitleDetailModel.ContentType(rawValue: type) {
            let titleDetailModel = TitleDetailModel(
                name: name,
                year: year,
                type: type,
                imdbID: imdbID
            )

            modelContext.insert(titleDetailModel)
        }
    }
}

#Preview {
    TitleDetailView(
        name: "The shawshank redemption",
        type: "movie",
        year: "1994",
        imdbID: "1"
    )
    .environment( \.titleDetailsRepository, TitleDetailsRepositoryMock(
        dataToReturn: TitleDetail.sample
    ))
    .modelContainer(.previewContainerTitles)
}
