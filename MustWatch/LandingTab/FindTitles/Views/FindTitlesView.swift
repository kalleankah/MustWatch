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
            SearchResultListView(
                titles: titles,
                selectedTitle: $selectedTitle
            )
            .searchable(text: $searchText, prompt: "Movies, shows, and episodes")
            .navigationTitle("Find titles")
            .toolbar {
                toolbar
            }
        }
        .task(id: searchText) {
            await debouncedSearch()
        }
        .overlay {
            loadingView
        }
        .overlay(alignment: .bottom) {
            ErrorOverlayView(
                error: error,
                action: {
                    retry()
                }
            )
        }
        .animation(.default, value: error)
        .sheet(isPresented: $isShowingFilters) {
            NavigationStack {
                TitleSearchFilterView(
                    type: $contentTypeFilter,
                    year: $yearFilter
                )
            }
        }
    }

    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShowingFilters = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .accessibilityLabel("Filter search results")
        }
    }

    var loadingView: some View {
        ProgressView()
            .controlSize(.large)
            .opacity(isSearching ? 1 : 0)
            .animation(.default, value: isSearching)
    }

    func retry() {
        error = nil
        Task {
            await debouncedSearch()
        }
    }

    func debouncedSearch() async {
        guard !searchText.isEmpty else {
            titles = []
            error = nil
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
            if case .requestCancelled = error {
                return
            }

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
