/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
            .onDelete(perform: { indexSet in
              // find the park at index
              indexSet.forEach { index in
                // 2. clear the local park here in the view
                if let dogParks = dog.parks,
                   dogParks.contains(parks[index]),
                   let dogParkIndex = dogParks.firstIndex(where: { $0.id == parks[index].id }) {
                  dog.parks?.remove(at: dogParkIndex)
                }
                // 1. remove the park in the data store, with autosave
                modelContext.delete(parks[index])
              }
            })
          }
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
