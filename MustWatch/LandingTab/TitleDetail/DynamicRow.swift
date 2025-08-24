//
//  DynamicRow.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-24.
//

import SwiftUI

struct DynamicRow: View {
    @Environment(\.dynamicTypeSize.isAccessibilitySize) private var isAccessibilitySize

    var heading: String
    var value: String

    var body: some View {
        if isAccessibilitySize {
            verticalLayout
        } else {
            horizontalLayout
        }
    }

    var horizontalLayout: some View {
        HStack(alignment: .top) {
            Text(heading)
            Spacer()
            Text(value)
                .font(.headline)
        }
    }

    var verticalLayout: some View {
        VStack(alignment: .leading) {
            Text(heading)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Small text size") {
    DynamicRow(heading: "Small text size", value: "Should appear horizontally")
        .environment(\.dynamicTypeSize, .large)

    DynamicRow(heading: "Large text size", value: "Should appear vertically")
        .environment(\.dynamicTypeSize, .accessibility1)
}
