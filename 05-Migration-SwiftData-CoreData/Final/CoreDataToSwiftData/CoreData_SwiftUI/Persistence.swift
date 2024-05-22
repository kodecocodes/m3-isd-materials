//
//  Persistence.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import CoreData

//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = UserInfo(context: viewContext)
//            //newItem. = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "CoreData_SwiftUI")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                Typical reasons for an error here include:
//                * The parent directory does not exist, cannot be created, or disallows writing.
//                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                * The device is out of space.
//                * The store could not be migrated to the current model version.
//                Check the error message to determine what the actual problem was.
//                */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//      
//    }
//}
//
//class UserContainer {
//  let container: NSPersistentContainer
//   
//  init(forPreview: Bool = false) {
//    container = NSPersistentContainer(name: "CoreData_SwiftUI")
//    
//    if forPreview {
//      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//    }
//    
//    container.loadPersistentStores { _, _ in }
//    
//    if forPreview {
//      addMockData(moc: container.viewContext)
//    }
//  }
//}
//
//extension UserContainer {
//  func addMockData(moc: NSManagedObjectContext) {
//    let user1 = UserInfo(context: moc)
//    user1.firstName = "Tim"
//    user1.lastName = "Mitra"
//    user1.gender = "Male"
//    
//    let user2 = UserInfo(context: moc)
//    user2.firstName = "Joe"
//    user2.lastName = "Smith"
//    user2.gender = "Male"
//    
//    let user3 = UserInfo(context: moc)
//    user3.firstName = "Jane"
//    user3.lastName = "Doe"
//    user3.gender = "Male"
//    
//    try? moc.save()
//  }
//}
