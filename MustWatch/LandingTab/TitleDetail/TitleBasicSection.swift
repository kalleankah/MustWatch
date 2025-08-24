//
//  TitleBasicSection.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-24.
//

import SwiftUI

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
                    DynamicRow(heading: heading, value: value)
                }
            }
            .padding()
            .background(.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    TitleBasicSection(
        header: "Some header",
        content: (1...10).map { index in
            ("Header \(index)", "Value \(index)")
        }
    )
}
