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
}

struct TitleBasicSection: View {
    let header: String
    let content: [(String, String)]

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.headline)
                .padding(.leading)

            VStack(spacing: 12) {
                ForEach(content, id: \.0) { heading, value in
                    HStack(alignment: .top) {
                        Text(heading)
                        Spacer()
                        Text(value)
                            .font(.headline)
                    }
                }
            }
            .padding()
            .background(.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct TitleDetailSection: View {
    let header: String
    let content: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.headline)
                .padding(.leading)

            Text(content)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private extension TitleDetail {
    var additionalInformation: [(String, String)] {
        [
            ("Released", released),
            ("Runtime", runtime),
            ("Genre", genre),
            ("Director", director),
            ("Country", country),
            ("Language", language),
            ("Writer", writer)
        ]
    }

    var reviews: [(String, String)] {
        [
            ("Metascore", metascore),
            ("imdbRating", imdbRating),
            ("imdbVotes", imdbVotes)
        ]
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
}
