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

    @State private var isSearching = false

    @State private var contentTypeFilter: Title.ContentType?
    @State private var yearFilter: Int?

    private let debounceDuration = Duration.milliseconds(500)

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
            }
            .navigationTitle("Find titles")
        }
        .task(id: searchText) {
            await debouncedSearch()
        }
        .overlay {
            ProgressView()
                .controlSize(.large)
                .opacity(isSearching ? 1 : 0)
                .animation(.default, value: isSearching)
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

    func debouncedSearch() async {
        guard !searchText.isEmpty else {
            titles = []
            return
        }

        isSearching = true

        do {
            try await Task.sleep(for: debounceDuration)

            await fetchTitles()
        } catch {

        }

        isSearching = false
    }

    func fetchTitles() async {
        do {
            titles = try await repository.searchTitles(
                by: searchText,
                type: contentTypeFilter,
                year: yearFilter
            )
        } catch {
            self.error = error
        }
    }
}

#Preview {
    FindTitlesView()
        .environment(\.titlesRepository, TitlesRepositoryMock())
}

#Preview("Response error") {
    let repositoryMock = TitlesRepositoryMock(error: .responseError)

    FindTitlesView()
        .environment(\.titlesRepository, repositoryMock)
}
