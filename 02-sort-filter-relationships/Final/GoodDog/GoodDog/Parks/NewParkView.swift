//
//  NewParkView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI
import SwiftData

struct NewParkView: View {
  @Environment(\.dismiss) var dismiss
  @State private var name = ""
  @Environment(\.modelContext) var modelContext
  
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
          let newPark = ParkModel(name: name)
          modelContext.insert(newPark)
          try! modelContext.save()
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
