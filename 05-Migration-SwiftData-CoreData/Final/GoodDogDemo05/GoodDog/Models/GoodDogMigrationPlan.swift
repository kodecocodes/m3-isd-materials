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

// MARK: - MODEL TYPE ALIASES
typealias DogModel = GoodDogSchemaV02_00_00.DogModel
typealias BreedModel = GoodDogSchemaV02_00_00.BreedModel
typealias ParkModel = GoodDogSchemaV02_00_00.ParkModel
typealias CityModel = GoodDogSchemaV02_00_00.CityModel

enum GoodDogMigrationPlan: SchemaMigrationPlan {
  
  static var schemas: [any VersionedSchema.Type] {
    [
      GoodDogSchemaV01_00_00.self,
      GoodDogSchemaV01_01_00.self,
      GoodDogSchemaV02_00_00.self
    ]
  }
  
  static let migrationV1_0_0toV1_1_0 = MigrationStage.lightweight(
    fromVersion: GoodDogSchemaV01_00_00.self,
    toVersion: GoodDogSchemaV01_01_00.self)
  
  // Park to city mapping for migrationV1_1_0toV2_0_0
  static var parkToCityDictionary: [String: String] = [:]
  
  static let migrationV1_1_0toV2_0_0 = MigrationStage.custom(
    fromVersion: GoodDogSchemaV01_01_00.self,
    toVersion: GoodDogSchemaV02_00_00.self) { context in
      // willMigrate: before migration
      guard let parks = try? context.fetch(FetchDescriptor<GoodDogSchemaV01_01_00.ParkModel>()) else { return }
      // save the mapping
      parkToCityDictionary = parks.reduce(into: [:], { dictionary, ParkModel in
        dictionary[ParkModel.name] = ParkModel.city
      })
    } didMigrate: { context in
      // after migration
      let uniqueCities = Set(parkToCityDictionary.values)
      // add cities to ParkModel
      for city in uniqueCities {
        context.insert(GoodDogSchemaV02_00_00.CityModel(name: city))
      }
      try? context.save()
      
      guard let parks = try? context.fetch(FetchDescriptor<GoodDogSchemaV02_00_00.ParkModel>()) else { return }
      guard let cities = try? context.fetch(FetchDescriptor<GoodDogSchemaV02_00_00.CityModel>()) else { return }
      // match park to city
      for parkToCity in parkToCityDictionary {
        guard let parkModel = parks.first(where: { $0.name == parkToCity.key }) else { return }
        guard let cityModel = cities.first(where: { $0.name == parkToCity.value }) else { return }
        parkModel.city = cityModel
        try? context.save()
      }
    }

  static var stages: [MigrationStage] {
    [migrationV1_0_0toV1_1_0, migrationV1_1_0toV2_0_0]
  }
}
