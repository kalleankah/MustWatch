//
//  TitleSearchFilterView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct TitleSearchFilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var type: Title.ContentType?
    @Binding var year: Int?

    @State var isShowingPicker = false

    var body: some View {
        Form {
            Section("Content type") {
                Picker("Type", selection: $type) {
                    let any: Title.ContentType? = nil
                    Text("Any")
                        .tag(any)
                    
                    ForEach(Title.ContentType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Release year") {
                TextField(value: $year, format: .number, prompt: Text("Release year")) {
                    Text("Hello world")
                }
                .keyboardType(.numberPad)
            }
        }
        .scrollContentBackground(.hidden)

        HStack(spacing: 64) {
            Button("Reset") {
                reset()
            }

            Button("Save") {
                dismiss()
            }
        }
        .font(.headline)
        .padding()
    }

    func reset() {
        type = nil
        year = nil
    }
}

#Preview {
    @Previewable @State var type: Title.ContentType? = nil
    @Previewable @State var year: Int? = nil

    TitleSearchFilterView(type: $type, year: $year)
}
