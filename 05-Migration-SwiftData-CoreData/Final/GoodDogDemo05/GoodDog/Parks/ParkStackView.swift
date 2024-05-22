//
//  CategoryStackView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI
import SwiftData

struct ParkStackView: View {
  @Environment(\.modelContext) private var modelContext
  /*@Query(sort: \ParkModel.name)*/ var parks: [ParkModel]
    var body: some View {
      HStack {
        ForEach(parks) { park in
          VStack {
            Text(park.name)
              .font(.caption)
            Text(park.city?.name ?? "n/a")
              .font(.caption2)
          }
          .foregroundColor(.white)
          .padding(5)
          .frame(width: 130)
          .background(RoundedRectangle(cornerRadius: 5).fill(.accent))
        }
      }
    }
}

//#Preview {
//  let container = try! ModelContainer(for: DogModel.self)
//  let toronto = CityModel(name: "Toronto")
//  let riverdale = ParkModel(name: "Riverdale Park")
//  riverdale.city = toronto
////  let withrow = ParkModel(name: "Withrow Park", city: toronto)
////  let greenwood = ParkModel(name: "Greewood Park", city: toronto)
//  let parks = [riverdale]
//  
//  return ParkStackView(parks: parks)
//    .modelContainer(container)
//}
