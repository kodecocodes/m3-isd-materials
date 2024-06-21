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

struct DogList: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var dogs: [DogModel]
  @State private var message = ""
  @State private var dogCount = 0
  @Environment(\.undoManager) private var undoManager
  
  init(sortOrder: SortOrder, filterString: String) {
    let sortDescriptors: [SortDescriptor<DogModel>] = switch sortOrder {
    case .name:
      [SortDescriptor(\DogModel.name)]
    case .age:
      [SortDescriptor(\DogModel.age),
       SortDescriptor(\DogModel.name)]
    }
    let predicate = #Predicate<DogModel> { dog in
      dog.breed?.name.localizedStandardContains(filterString) ?? false
      || dog.name.localizedStandardContains(filterString)
      || filterString.isEmpty
    }
    _dogs = Query(filter: predicate, sort: sortDescriptors)
  }
  
    var body: some View {
      Group {
        if !dogs.isEmpty {
          List {
            ForEach(dogs) { dog in
              NavigationLink {
                EditDogView(dog: dog)
              } label: {
                HStack {
                  if let photoData = dog.image, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                      .resizable()
                      .scaledToFill()
                      .frame(maxWidth: 80, maxHeight: 80)
                      .clipShape(RoundedRectangle(cornerRadius: 5.0))
                  } else {
                    Image(systemName: "dog")
                      .imageScale(.large)
                      .frame(maxWidth: 80, maxHeight: 80)
                      .foregroundStyle(.tint)
                  }
                  VStack(alignment: .leading) {
                    Text(dog.name)
                      .font(.title2)
                    HStack {
                      Text("age: \(String(describing: dog.age ?? 0))")
                      Text("breed: \(String(describing: dog.breed?.name ?? ""))")
                    }
                    .font(.footnote)
                  }
                }
              }
            }
            .onDelete(perform:dogToDelete)
          }
        } else {
          ContentUnavailableView(message, systemImage: "dog")
        }
      }
      .toolbar {
        ToolbarItem {
          Button("Undo", systemImage: "arrow.uturn.left") {
            withAnimation {
              modelContext.undoManager?.undo()
            }
          }
          .disabled(modelContext.undoManager?.canUndo == false)
        }
      }
      .task() {
        dogCount = dogs.count
        if dogCount == 0 {
          message = "Enter a dog."
        } else {
          message = "No dogs found."
        }
      }
    }
  func dogToDelete(indexSet: IndexSet) {
    for index in indexSet {
      modelContext.delete(dogs[index])
    }
  }
}

#Preview {
  DogList(sortOrder: .name, filterString: "")
    .modelContainer(DogModel.preview)
}
