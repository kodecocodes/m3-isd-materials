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

@main
struct GoodDogApp: App {
    var body: some Scene {
        WindowGroup {
            DogListView()
                .modelContainer(container)
        }
    }
  
  @MainActor
  var container: ModelContainer {
    do {
      let schema = Schema([DogModel.self])
      let config = ModelConfiguration("GoodDogs", schema: schema)
      let container = try! ModelContainer(for: schema, configurations: config)
      //container.mainContext.autosaveEnabled = false
      // here's the undo
      container.mainContext.undoManager = UndoManager()
      container.mainContext.undoManager?.levelsOfUndo = 2

      // check that there are no dogs in the store
      var dogFetchDescriptor = FetchDescriptor<DogModel>()
      dogFetchDescriptor.fetchLimit = 1
      guard try container.mainContext.fetch(dogFetchDescriptor).count == 0 else { return container }

      let dogs = [
      DogModel(
        name: "Rover",
        breed: BreedModel(name: "Unknown Breed")
      )
    ]

      for dog in dogs {
        container.mainContext.insert(dog)
      }

      return container
    } catch {
      fatalError("Failed to create container")
    }
  }
  
  init() {
    print(URL.applicationSupportDirectory.path(percentEncoded: false))
  }
}
