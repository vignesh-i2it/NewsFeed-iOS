//
//  SwiftUIView.swift
//  NewsCast
//
//  Created by Vignesh on 11/04/23.
//

import SwiftUI
import CoreData

struct SignInView: View {
    
    @Environment(\.managedObjectContext) var moc

    @Environment(\.dismiss) private var dismiss
        
    @State var email: String = "tom@gmail.com"
    @State var password: String = "password"
    @State var isShowAlert : Bool = false
    
    @State var success: Bool = false
    
    private func search(email:String, pwd:String) -> User?{
        var user : User?
        let request = User.fetchRequest() // NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, pwd)

        do {
            let results = try moc.fetch(request)
            if results.count > 0{
                user =  results[0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }
    
    private func searchActiveUser() -> User?{
        var user : User?
        let request = User.fetchRequest() // NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "isActive == true")

        do {
            let results = try moc.fetch(request)
            if results.count > 0{
                user =  results[0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }

    var body: some View {
        NavigationView{
            VStack {
                Text("NewsCast")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)

                
                SecureField("password", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )

//                FilteredList(email: email)
                
                NavigationLink(destination:
                                MainTabView(),isActive: self.$success) {EmptyView()}.hidden()
                Button("Sign in"){
                    if email.count > 0 && password.count > 0{
                        let user =  search(email: $email.wrappedValue, pwd: $password.wrappedValue)
                        let activeUser = searchActiveUser()
                        if user == nil{
                            success = false
                            isShowAlert = true
                        } else {
                            success = true
                            //let user = User(context: moc)
                            activeUser?.isActive = false
                            user?.isActive = true //??
                            
                            do {
                                try moc.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        isShowAlert = true
                    }
                }.font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .cornerRadius(50)
                    .padding()
                    .alert("Enter valid credentials", isPresented: $isShowAlert) {
                                Button("OK", role: .cancel) { }
                            }

                NavigationLink("Create Account") {
                    SignUpView()
                }
                .font(.title3)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

/*  NavigationLink( destination: ContentView(), isActive: $success){
      Text("Sign in")
  }.simultaneousGesture(TapGesture().onEnded{
      let user =  search(email: $email.wrappedValue, pwd: $password.wrappedValue)
      if user == nil{
          success = false
          isShowAlert = true
      }else{
          success = true
      }
  })
  .font(.title3)
  .foregroundColor(.white)
  .frame(width: 200, height: 50)
  .background(.blue)
  .cornerRadius(50)
  .padding()
  .alert("Enter valid credentials", isPresented: $isShowAlert) {
              Button("OK", role: .cancel) { }
          }
  */
  
 /* NavigationLink(destination: ContentView()) {
      Text("Sign in")
  }.simultaneousGesture(TapGesture().onEnded{
      let user =  search(email: $email.wrappedValue, pwd: $password.wrappedValue)
      if user == nil{
          isShowAlert = true
      }
  })
  .font(.title3)
  .foregroundColor(.white)
  .frame(width: 200, height: 50)
  .background(.blue)
  .cornerRadius(50)
  .padding()
  .alert("Enter valid credentials", isPresented: $isShowAlert) {
              Button("OK", role: .cancel) { }
          }*/

  
//                Button("Sign In") {
//                  let user =  search(email: $email.wrappedValue, pwd: $password.wrappedValue)
//                    if user == nil{
//                        isShowAlert = true
//                    }
//                }.alert("Enter valid credentials", isPresented: $isShowAlert) {
//                    Button("OK", role: .cancel) { }
//                }


//                NavigationLink("filterlistview") {
//                    FilteredList(email: email)
//                }
//                .font(.title3)

  
  
//                Button("Sign in ") {
//
//
//
//
//                }
//                .font(.title3)
//                .foregroundColor(.white)
//                .frame(width: 100, height: 50)
//                .background(.blue)
//                .cornerRadius(50)
//                .padding()
//                .alert("A user with this email already exists", isPresented: $showingAlert) {
//                            Button("OK", role: .cancel) { }
//                        }
//
//                NavigationLink(destination: ContentView()) {
//                    Text("Login")
//                }.simultaneousGesture(TapGesture().onEnded{
//                    //action
//                })
//                .font(.title3)
//                .foregroundColor(.white)
//                .frame(width: 100, height: 50)
//                .background(.blue)
//                .cornerRadius(50)
//                .padding()
  




//    @FetchRequest(
//        entity: User.entity(),
//        sortDescriptors: [],
//        predicate: NSPredicate(format: "email == %@ AND password == %@", $email.wrappedValue, "password")) var fetchRequest: FetchedResults<User>
//
//
//
//    init() {
//        _fetchRequest = FetchRequest<User>(sortDescriptors: [], predicate: NSPredicate(format: "email == %@ AND password == %@", email, "password"))
//    }

    

//
//        init(id objectID: NSManagedObjectID, in context: NSManagedObjectContext) {
//                if let person = try? context.existingObject(with: objectID) as? Person {
//                    self.person = person
//                } else {
//                    // if there is no object with that id, create new one
//                    self.person = Person(context: context)
//                    try? context.save()
//                }
//            }
