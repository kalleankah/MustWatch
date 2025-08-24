//
//  TitleDetailSection.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-24.
//

import SwiftUI

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

#Preview {
    TitleDetailSection(
        header: "Section header",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu."
    )
}
