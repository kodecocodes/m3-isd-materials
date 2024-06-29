/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
