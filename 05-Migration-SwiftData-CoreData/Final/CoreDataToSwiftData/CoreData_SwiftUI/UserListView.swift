//
//  ContentView.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI
//1
import SwiftData

struct UserListView: View {
  // 2
  @Environment(\.managedObjectContext) private var modelContext
  // 3
  @Query(sort: \UserInfo.firstName, order: .forward) var users: [UserInfo]
  
  @State private var showingAddUser = false

    var body: some View {
      NavigationView{
        List {
          ForEach(users) { userInfo in
            NavigationLink{
              Text("\(userInfo.firstName ?? "Joe") \(userInfo.lastName ?? "")")
            } label: {
              VStack(alignment: .leading) {
                Text("\(userInfo.firstName ?? "") \(userInfo.lastName ?? "")")
                  .font(.title)
              }
            }
          }
          .onDelete(perform: deleteUser)
          if users.count == 0 {
            Text("No user found")
          }
        }
        .navigationBarTitle("Users")
        .navigationBarItems(leading: EditButton(), trailing: Button("Add"){
          self.showingAddUser.toggle()
       })
        .sheet(isPresented: $showingAddUser) {
          UserInfoView().environment(\.managedObjectContext, self.modelContext)
        }

      }
    }
  
  func deleteUser(indexSet: IndexSet) {
    for index in indexSet {
  //    modelContext.delete(users[index])
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      UserListView()
        // 4 & 5 - add mock Data
        .modelContainer(UserInfo.preview)
    }
}
