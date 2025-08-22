//
//  FindMovieView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct FindTitlesView: View {
    @Environment(\.titlesRepository) var repository

    @State var titles: [Title] = []
    @State private var searchText: String = ""
    @State private var error: TitlesSearchError?

    @State private var isShowingFilters = false
    @State private var selectedTitle: Title?

    @State private var contentTypeFilter: Title.ContentType?
    @State private var yearFilter: Int?

    var isShowingResults: Bool {
        !searchText.isEmpty || !titles.isEmpty
    }

    var isRatingTitle: Bool {
        selectedTitle != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(titles, id: \.imdbID) { title in
                    NavigationLink(value: title) {
                        TitleListItem(
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
                    TitleDetailView(
                        name: title.name,
                        type: title.type.rawValue,
                        year: title.year
                    )
                }
                .searchable(text: $searchText, prompt: "Movies, shows, and episodes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingFilters = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        .accessibilityLabel("Filter search results")
                    }
                }

                Button {
                    fetchTitles()
                } label: {
                    Text("Search")
                        .font(.system(size: 18, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .padding(.horizontal, 48)
                .padding(.bottom, 24)
            }
            .navigationTitle("Find titles")
        }
        .alert(
            error?.localizedDescription ?? "",
            isPresented: Binding(
                get: { error != nil},
                set: { isPresented in
                    if !isPresented {
                        error = nil
                    }
                }
            ),
            presenting: error,
            actions: { error in
                Button("Close") {}
            }
        )
        .sheet(isPresented: $isShowingFilters) {
            NavigationStack {
                TitleSearchFilterView(
                    type: $contentTypeFilter,
                    year: $yearFilter
                )
                .navigationTitle("Filter search results")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func fetchTitles() {
        Task {
            do {
                titles = try await repository.searchTitles(
                    by: searchText,
                    type: contentTypeFilter,
                    year: yearFilter
                )
            } catch is TitlesSearchError {
                self.error = error
            }
        }
    }
}

#Preview {
    FindTitlesView()
        .environment(\.titlesRepository, TitlesRepositoryMock())
}
