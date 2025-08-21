//
//  LandingTabView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct LandingTabView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Find", systemImage: "magnifyingglass")
                }

            MyFavorites()
                .tabItem {
                    Label("My titles", systemImage: "heart")
                }
        }
    }
}

#Preview {
    LandingTabView()
}
