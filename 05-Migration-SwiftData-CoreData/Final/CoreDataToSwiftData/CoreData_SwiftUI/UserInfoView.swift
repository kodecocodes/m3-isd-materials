//
//  UserInfoView.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI

struct UserInfoView: View {
  @Environment(\.modelContext) private var modelContext
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
            Button("Add User") {
              addItem()
              dismiss()
            }
          }
        }
        .navigationBarTitle("User Info View")
      }
    }
  
  private func addItem() {
      withAnimation {
        let newUser = UserInfo(firstName: firstName, lastName: lastName, gender: gender)
        modelContext.insert(newUser)
      }
  }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
