//
//  CategoriesView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI

struct ParksView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var newPark = false
  
  var body: some View {
    NavigationStack {
      Group {
          List {
            ForEach(1...4, id:\.self) { park in
              Text("Nice Park")
            }
          }
          LabeledContent {
            Button {
              
            } label: {
              Image(systemName: "plus.circle.fill")
                .imageScale(.large)
            }
            .buttonStyle(.borderedProminent)
          } label: {
            Text("Create new park")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
      }
      .navigationTitle("My Dog's parks")
      .sheet(isPresented: $newPark) {
        NewParkView()
      }
    }
  }
}




#Preview {
  ParksView()
}
