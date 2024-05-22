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

struct NewDogView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State var name = ""
  
  @Query(filter: #Predicate<BreedModel> { breed in
    breed.name == "Unknown Breed"
  }) private var breeds: [BreedModel]

    var body: some View {
      NavigationStack{
        List {
          Section {
            VStack {
              TextField("Dog Name", text: $name)
            }
          }
          Section {
            Button("Create") {
              let breed: BreedModel
              if breeds.isEmpty {
                breed = BreedModel(name: "Unknown Breed")
              } else {
                breed = breeds[0]
              }
              let newDog = DogModel(name: name, breed: breed)
              modelContext.insert(newDog)
              dismiss()
            }
            
          }
          .frame(maxWidth: .infinity, alignment: .trailing)
          .buttonStyle(.borderedProminent)
          .disabled(name.isEmpty)
        }
        .navigationTitle("New Dog")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
          ToolbarItem (placement: .topBarLeading) {
            Button("Cancel") {
              dismiss()
            }
          }
        }
#else
        .toolbar{
          ToolbarItem (placement: .automatic) {
            Button("Cancel") {
              dismiss()
            }
          }
        }
#endif
      }
    }
}

#Preview {
  NewDogView()
    .modelContainer(DogModel.preview)
}
