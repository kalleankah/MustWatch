//
//  TitleSearchFilterView.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-21.
//

import SwiftUI

struct SearchFilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var type: TitleContentType?
    @Binding var year: Int?

    @State var isShowingPicker = false

    var body: some View {
        Form {
            Section("Content type") {
                Picker("Type", selection: $type) {
                    let any: TitleContentType? = nil
                    Text("Any")
                        .tag(any)
                    
                    ForEach(TitleContentType.allCases, id: \.self) { type in
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
        .navigationTitle("Filter search results")
        .navigationBarTitleDisplayMode(.inline)

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
    @Previewable @State var type: TitleContentType? = nil
    @Previewable @State var year: Int? = nil

    SearchFilterView(type: $type, year: $year)
}
