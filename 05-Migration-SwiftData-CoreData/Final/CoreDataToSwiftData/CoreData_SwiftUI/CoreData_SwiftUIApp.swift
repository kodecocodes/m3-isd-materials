//
//  CoreData_SwiftUIApp.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI
import SwiftData

@main
struct CoreData_SwiftUIApp: App {
  
  var body: some Scene {
    WindowGroup {
      UserListView()
    }
    .modelContainer(for: [UserInfo.self])
  }
}
