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

struct DogListView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Query private var dogs: [DogModel]
  @State private var showingNewDogScreen = false
  @State private var sortOrder = SortOrder.name
  @State private var filter = ""
  @State private var selectedDog: DogModel?

  var body: some View {
    NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
      DogList(sortOrder: sortOrder, filterString: filter)
        .searchable(text: $filter, prompt: Text("Filter on name or breed"))
      .navigationTitle("Good Dogs")
      .padding()
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Add New Dog", systemImage: "plus") {
            showingNewDogScreen = true
          }
        }
      }
      .sheet(isPresented: $showingNewDogScreen) {
        NewDogView(name: "")
          .presentationDetents([.medium, .large])
      }
      .toolbar {
        ToolbarItem {
          Menu("Sort", systemImage: "arrow.up.arrow.down") {
            Picker("Sort Dogs", selection: $sortOrder) {
              ForEach(SortOrder.allCases) { sortOrder in
                Text("Sort By: \(String(describing: sortOrder))").tag(sortOrder)
              }
            }
            .buttonStyle(.bordered)
            .pickerStyle(.inline)
          }
        }
      }
    } detail: {
      if let selectedDog {
        NavigationLink(value: selectedDog) {
          EditDogView(dog: selectedDog)
        }
      } else {
        Text("Select a dog!")
      }
    }
    .navigationSplitViewStyle(.balanced)
    .frame(minWidth: 250)
  }
}

#Preview {
  DogListView()
    .modelContainer(DogModel.preview)
}
