//
//  CoreData_SwiftUIApp.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI

@main
struct CoreData_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            UserListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
