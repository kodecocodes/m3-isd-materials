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
import PhotosUI
import SwiftData

struct EditDogView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Bindable var dog: DogModel
  @State private var name: String = ""
  @State private var age: Int = 0
  @State private var weight: Int = 0
  @State private var color: String = ""
  @State private var breed: BreedModel?
  @State private var image: Data?
  @State private var showBreeds = false
  @State private var showParks = false
  @State private var didAppear = false

  @State var selectedPhoto: PhotosPickerItem?
  // check if any values are changed
  var changed: Bool {
    name != dog.name
    || age != dog.age
    || weight != dog.weight
    || color != dog.color
    || breed != dog.breed
    || image != dog.image
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        // MARK: - A Dog
        GroupBox {
          Section {
            // unwrap selectedPhotoData for preview
            if let imageData = image,
               let uiImage = UIImage(data: imageData) {
              Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)
            }
            // MARK: - Photo Picker
            HStack {
              PhotosPicker(selection: $selectedPhoto,
                           matching: .images,
                           photoLibrary: .shared()) {
                Label("Update Image", systemImage: "photo")
              }
              // remove selected image
              if image != nil {
                Button(role: .destructive) {
                  withAnimation {
                    selectedPhoto = nil
                    image = nil
                  }
                } label: {
                  Label("Remove Image", systemImage: "xmark")
                    .foregroundColor(.red)
                }
              }
            }
            LabeledContent {
              TextField("", text: $name)
            } label: {
              Text("Dog Name")
                .foregroundStyle(.secondary)
            }
            LabeledContent {
              TextField("", value: $age, format: .number)
            } label: {
              Text("Dog Age")
                .foregroundStyle(.secondary)
            }
            LabeledContent {
              TextField("", value: $weight, format: .number)
            } label: {
              Text("Dog Weight")
                .foregroundStyle(.secondary)
            }
            LabeledContent {
              TextField("", text: $color)
            } label: {
              Text("Color")
                .foregroundStyle(.secondary)
            }
            // MARK: - Breeds
            HStack {
              BreedPicker(selectedBreed: $breed)
              Button("Edit Breeds") {
                showBreeds = true
              }
              .buttonStyle(.borderedProminent)
            }
            // MARK: - Parks
            VStack {
              Button("Parks", systemImage: "tree") {
                showParks.toggle()
              }
              .buttonStyle(.borderedProminent)
            }
          }
          VStack {
            if let parks = dog.parks {
              ViewThatFits {
                ScrollView(.horizontal, showsIndicators: false) {
                  ParkStackView(parks: parks)
                }
              }
            }
          }
        }
        .onChange(of: dog) {
          name = dog.name
          age = dog.age ?? 0
          weight = dog.weight ?? 0
          color = dog.color ?? ""
          image = dog.image
        }
      }
      .sheet(isPresented: $showBreeds) {
        BreedListView()
          .presentationDetents([.large])
      }
      .sheet(isPresented: $showParks) {
        ParksView(dog: dog)
          .presentationDetents([.large])
      }      
      .textFieldStyle(.roundedBorder)
      .navigationTitle(name)
      .navigationBarTitleDisplayMode(.inline)
      // MARK: - onAppear
      .onAppear {
        name = dog.name
        age = dog.age ?? 0
        weight = dog.weight ?? 0
        color = dog.color ?? ""
        breed = dog.breed
        image = dog.image

        didAppear = true
      }
      .task(id: selectedPhoto) {
       // the photo picker has a protocol to convert to Data or whatever
       if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
         image = data
       }
      }
      .toolbar {
        if didAppear && changed {
          Button("Update") {
            dog.name = name
            dog.age = age
            dog.weight = weight
            dog.color = color
            dog.breed = breed
            dog.image = image
            dismiss()
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
  }
}

#Preview {
  do {
    let container = try ModelContainer(for: DogModel.self)
    let dog = DogModel(
      name: "Mac",
      age: 11,
      weight: 90,
      color: "Yellow",
      image: UIImage(resource: .macintosh).pngData()!
    )
    
    return EditDogView(dog: dog)
      .modelContainer(container)
  } catch {
    fatalError("Fatal Error: Could not create ModelContainer. Error: \(error)")
  }
}
