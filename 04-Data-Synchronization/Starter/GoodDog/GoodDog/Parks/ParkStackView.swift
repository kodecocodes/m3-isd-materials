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
  var parks: [ParkModel]
  
  var body: some View {
    HStack {
      ForEach(parks) { park in
        Text(park.name)
          .font(.caption)
          .foregroundColor(.white)
          .padding(5)
          .frame(width: 100)
          .background(RoundedRectangle(cornerRadius: 5).fill(.accent))
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(for: DogModel.self)
  let riverdale = ParkModel(name: "Riverdale Park")
  let withrow = ParkModel(name: "Withrow Park")
  let greenwood = ParkModel(name: "Greewood Park")
  let parks = [riverdale, withrow, greenwood]
  
  return ParkStackView(parks: parks)
    .modelContainer(container)
}
