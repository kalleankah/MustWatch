//
//  ErrorOverlayView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftUI

struct ErrorOverlayView: View {
    var error: TitlesError?
    var action: (() -> Void)?
    var actionAccessibilityHint: String?

    var isWarning: Bool {
        error == .tooManyResults
    }

    var body: some View {
        if let errorDescription = error?.errorDescription {
            Button {
                action?()
            } label: {
                Text(errorDescription)
                    .font(.headline)
                    .foregroundStyle(isWarning ? .black : .white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isWarning ? .yellow : .red)
            }
            .accessibilityHint(actionAccessibilityHint ?? "")
        }
    }
}

#Preview {
    @Previewable @State var error = TitlesError.responseError

    ErrorOverlayView(error: error)
}
