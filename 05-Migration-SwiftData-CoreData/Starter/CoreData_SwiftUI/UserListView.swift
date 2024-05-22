//
//  ContentView.swift
//  CoreData_SwiftUI
//
//  Created by Tim Mitra on 2/24/21.
//

import SwiftUI
import CoreData

struct UserListView: View {
    @Environment(\.managedObjectContext) private var moc

  @FetchRequest(sortDescriptors: []) var users: FetchedResults<UserInfo>
  
  @State private var showingAddUser = false

    var body: some View {
      NavigationView{
        List {
          //Text("Core Data")
          ForEach(users, id: \.self) { userInfo in
            NavigationLink{
              //EditUserView(userInfo: userInfo)
              Text("\(userInfo.firstName ?? "Joe") \(userInfo.lastName ?? "")")
            } label: {
              VStack(alignment: .leading) {
                Text("\(userInfo.firstName ?? "") \(userInfo.lastName ?? "")")
                  .font(.title)
              }
            }
          }
          .onDelete(perform: deleteUser(at:))
          if users.count == 0 {
            Text("No user found")
          }
        }
        .navigationBarTitle("Users")
        .navigationBarItems(leading: EditButton(), trailing: Button("Add"){
          self.showingAddUser.toggle()
       })
        .sheet(isPresented: $showingAddUser) {
          UserInfoView().environment(\.managedObjectContext, self.moc)
        }

      }
    }
  
  func deleteUser(at offsets: IndexSet) {
      for index in offsets {
          let user = users[index]
          moc.delete(user)
      }
      try? moc.save()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      UserListView().environment(\.managedObjectContext, UserContainer(forPreview: true).container.viewContext)
    }
}
