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
  @Environment(\.modelContext) private var modelContext
  @Bindable var dog: DogModel // be able to update properties
  @Query(sort: \ParkModel.name) var parks: [ParkModel]
  @State private var newPark = false
  
  var body: some View {
    NavigationStack {
      Group {
        if parks.isEmpty {
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
        } else {
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
                      Image(systemName: dogParks.contains(park) ? "circle.fill" : "circle" )
                    }
                  }
                }
                Text(park.name)
              }
            }
            .onDelete(perform: { indexSet in
              // loop through to find the index of the park
              indexSet.forEach { index in
                // 2. clear the local park here in the view
                if let dogParks = dog.parks,
                   dogParks.contains(parks[index]),
                   let dogParkIndex = dogParks.firstIndex(where: { $0.id == parks[index].id }) {
                  dog.parks?.remove(at: dogParkIndex)
                }
                // 1. remove the park in the data store
                modelContext.delete(parks[index])
              }
            })
            LabeledContent {
              Button {
                newPark.toggle()
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
        }
      }
      .navigationTitle(dog.name)
      .sheet(isPresented: $newPark) {
        NewParkView()
      }
      .toolbar{
#if os(macOS)
          ToolbarItem(placement: .automatic) {
            Button("Close") {
              dismiss()
            }
          }
#else
          ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") {
              dismiss()
            }
          }
#endif

      }
    }
  }
  func addRemove(_ park: ParkModel) {
    if let dogParks = dog.parks {
      if dogParks.isEmpty {
        dog.parks?.append(park)
      } else {
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
  let dog = DogModel(name: "Mac", age: 11, weight: 90, color: "Yellow"/*, breed: breed*/, image: nil)
  return ParksView(dog: dog)
    .modelContainer(container)
}
