//
//  CategoriesView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI
import SwiftData

struct ParksView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var newPark = false
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \ParkModel.name) var parks: [ParkModel]
  @Bindable var dog: DogModel
  
  var body: some View {
    NavigationStack {
      Group {
        if !parks.isEmpty {
          List {
            ForEach(parks) { park in
              Text(park.name)
            }
          }
          LabeledContent {
            Button {
              // addRemove will go here
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
        } else {
          ContentUnavailableView {
            Image(systemName: "tree")
          } description: {
            Text("You need to create some parks.")
          } actions: {
            Button("Create Park") {
              newPark.toggle()
            }
            .buttonStyle(.borderedProminent)
          }
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
  let container = try! ModelContainer(for: DogModel.self)
  let parks = [
    ParkModel(name: "Riverdale"),
    ParkModel(name: "Withrow")
  ]
  let dog = DogModel(name: "Mac", parks: parks)
  return ParksView(dog: dog)
    .modelContainer(container)
}
