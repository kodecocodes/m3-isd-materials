//
//  CategoryStackView.swift
//  MyJobs
//
//  Created by Tim Mitra on 2023-12-03.
//

import SwiftUI

struct ParkStackView: View {
  
  var body: some View {
    HStack {
      ForEach(1...4, id: \.self) { park in
        Text("Dock Park")
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
  ParkStackView()
}
