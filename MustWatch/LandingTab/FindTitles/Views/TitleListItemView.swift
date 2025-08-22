//
//  TitleListItemView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleListItemView: View {
    let name: String
    let type: String
    let year: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(type)
                    .font(.subheadline)
                    .foregroundStyle(.foreground.opacity(0.7))
            }
            
            Spacer()
            
            Text(year)
        }
    }
}

#Preview {
    TitleListItemView(name: "Harry potter", type: "movie", year: "2004")
}
