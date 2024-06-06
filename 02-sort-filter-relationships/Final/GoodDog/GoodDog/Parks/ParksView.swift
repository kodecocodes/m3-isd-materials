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
              HStack {
                if let dogParks = dog.parks {
                  if dogParks.isEmpty {
                    Button {
                      addRemove(park)
                    } label: {
                      Image(systemName: "circle")
                    }
                  } else {
                    Button {
                      addRemove(park)
                    } label: {
                      Image(
                        systemName: 
                          dogParks.contains(
                            park
                        ) ? "circle.fill" : "circle"
                      )
                    }
                  }
                }
                Text(park.name)
              }
            }
          }
          LabeledContent {
            Button {
              // newPark.toggle will go here
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
  func addRemove(_ park: ParkModel) {
    if let dogParks = dog.parks {
      // check if parks is empty
      if dogParks.isEmpty {
        dog.parks?.append(park)
      } else {
        // check if park is associated
        // remove park if true
        // add park if false
        if dogParks.contains(park),
            let index = dogParks.firstIndex(where: {
              $0.id == park.id
            }) {
          dog.parks?.remove(at: index)
        } else {
          dog.parks?.append(park)
        }
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(for: DogModel.self)
  let dog = DogModel(name: "Mac", parks: [])
  return ParksView(dog: dog)
    .modelContainer(container)
}
