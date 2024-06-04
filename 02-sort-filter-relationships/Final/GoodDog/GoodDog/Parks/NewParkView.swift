//
//  NewParkView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI

struct NewParkView: View {
  @Environment(\.dismiss) var dismiss
  @State private var name = ""
  
  var body: some View {
    NavigationStack {
      GroupBox {
        LabeledContent {
          TextField("Name", text: $name)
        } label: {
          Text("Name")
            .foregroundStyle(.secondary)
        }
        Button("Add Park") {
          dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(name.isEmpty)
        Spacer()
      }
      .padding()
      .navigationTitle("New Park") // this works on macOS
    }
  }
}

#Preview {
  NewParkView()
}
