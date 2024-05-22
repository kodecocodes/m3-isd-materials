//
//  UserInfoView.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI

struct UserInfoView: View {
  @Environment(\.managedObjectContext) private var moc
  @Environment(\.dismiss) private var dismiss
  @State private var firstName = ""
  @State private var lastName = ""
  @State private var gender = ""
  @State private var isAlert = false

  private let genders = ["Male", "Female"]

    var body: some View {
      NavigationView{
        Form {
          Section {
            TextField("Enter first name", text: $firstName)
              .disableAutocorrection(true)
            TextField("Enter last name", text: $lastName)
              .disableAutocorrection(true)
            Picker("Select gender", selection: $gender) {
              ForEach(genders, id: \.self) { gender in
                Text(gender)
              }
            }
            Button(action: addItem) {
              Text("Add User")
            }
          }
        }
        .navigationBarTitle("User Info View")
      }
    }
  
  private func addItem() {
      withAnimation {
          let newItem = UserInfo(context: moc)
        newItem.firstName = firstName
        newItem.lastName = lastName
        newItem.gender = gender
          do {
              try moc.save()
              dismiss()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
      }
  }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
