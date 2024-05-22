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

import Foundation
import SwiftData

// MARK: - Version 1.1.0
enum GoodDogSchemaV01_01_00: VersionedSchema {
  static var versionIdentifier = Schema.Version(1, 1, 0)
  
  static var models: [any PersistentModel.Type] {
    [DogModel.self, BreedModel.self, ParkModel.self]
  }
  
  @Model
  class DogModel {
    var name: String = "Rover"
    var age: Int?
    var weight: Int?
    var color: String?
    /*@Relationship(inverse: \BreedModel.dog) */
    var breed: BreedModel?
    @Attribute(.externalStorage) var image: Data?
    var parks: [ParkModel]?
    
    init(
      name: String = "",
      age: Int = 0,
      weight: Int = 0,
      color: String? = nil,
      breed: BreedModel? = nil,
      image: Data? = nil,
      parks: [ParkModel]? = nil
    ) {
      self.name = name
      self.age = age
      self.weight = weight
      self.color = color
      self.breed = breed
      self.image = image
      self.parks = parks
    }
  }
  
  @Model
  class BreedModel {
    var name: String = "Unknown Breed"
    var dogs: [DogModel]?
    
    init(name: String) {
      self.name = name
    }
  }

  @Model
  class ParkModel {
    var name: String = ""
    var dogs: [DogModel]?
    var city: String?
    
    init(name: String, dogs: [DogModel]? = nil, city: String?) {
      self.name = name
      self.dogs = dogs
      self.city = city
    }
  }


}



// MARK: - Version 1.1.0 extension
extension GoodDogSchemaV01_01_00.DogModel {
  @MainActor
  static var preview: ModelContainer {
    let container = try! ModelContainer(for: DogModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

//    let labrador = BreedModel(name: "Labrador Retriever")
//    let golden = BreedModel(name: "Golden Retriever")
//    let bouvier = BreedModel(name: "Bouvier")
//    let mixed = BreedModel(name: "Mixed")
//    
//    let riverdale = ParkModel(name: "Riverdale Park", city: "Toronto")
//    let withrow = ParkModel(name: "Withrow Park", city: nil)
//    let greenwood = ParkModel(name: "Greewood Park", city: "Toronto")
//    let hideaway = ParkModel(name: "Hideaway Park", city: "Toronto")
//    let kewBeach = ParkModel(name: "Kew Beach Off Leash Dog Park", city: "Toronto")
//    let allan = ParkModel(name: "Allan Gardens", city: "")
//
//    let macDog = DogModel(name: "Mac", age: 11, weight: 90, color: "Yellow", image: nil)
//    let sorcha = DogModel(name: "Sorcha", age: 1, weight: 40, color: "Yellow", image: nil)
//    let violet = DogModel(name: "Violet", age: 4, weight: 85, color: "Gray", image: nil)
//    let kirby = DogModel(name: "Kirby", age: 11, weight: 95, color: "Fox Red", image: nil)
//    let priscilla = DogModel(name: "Priscilla", age: 17, weight: 65, color: "White", image: nil)
//    
//    container.mainContext.insert(macDog)
//    macDog.breed = labrador
//    macDog.parks = [riverdale, withrow, kewBeach]
//    container.mainContext.insert(sorcha)
//    sorcha.breed = golden
//    sorcha.parks = [greenwood, withrow]
//    container.mainContext.insert(violet)
//    violet.breed = bouvier
//    violet.parks = [riverdale, withrow, hideaway]
//    container.mainContext.insert(kirby)
//    kirby.breed = labrador
//    kirby.parks = [allan, greenwood, kewBeach]
//    container.mainContext.insert(priscilla)
//    priscilla.breed = mixed

    return container
  }
}
