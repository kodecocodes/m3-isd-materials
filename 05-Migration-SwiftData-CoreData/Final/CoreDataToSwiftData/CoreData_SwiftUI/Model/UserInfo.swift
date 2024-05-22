//
//  UserInfo.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2024-05-21.
//
//

import Foundation
import SwiftData


@Model
public class UserInfo {
  var firstName: String?
  var lastName: String?
  var gender: String?
  
  init(firstName: String? = nil, lastName: String? = nil, gender: String? = nil) {
    self.firstName = firstName
    self.gender = gender
    self.lastName = lastName
  }
}

// 5
extension UserInfo {
  @MainActor
  static var preview: ModelContainer {
    let container = try! ModelContainer(for: UserInfo.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let user1 = UserInfo(firstName: "Tim", lastName: "Mitra", gender: "Male")
    let user2 = UserInfo(firstName: "Joe", lastName: "Smith", gender: "Male")
    let user3 = UserInfo(firstName: "Jane", lastName: "Doe", gender: "Male")
                         
    container.mainContext.insert(user1)
    container.mainContext.insert(user2)
    container.mainContext.insert(user3)
    
    return container
  }
}
