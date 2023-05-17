//
//  AuthView.swift
//  NewsCast
//
//  Created by Vignesh on 10/05/23.
//

import SwiftUI
import iPhoneNumberField

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    
     
    var body: some View {
        if let viewModelFactory = viewModel.makeViewModelFactory() {
            MainTabView()
                .environmentObject(viewModelFactory)
        } else {
            NavigationView {
                SignInForm(viewModel: viewModel.makeSignInViewModel()) {
                    NavigationLink("Create Account", destination: CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel()))
                        .font(.title3)
                }
            }
        }
    }
}

private extension AuthView {
    struct CreateAccountForm: View {
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        
        @Environment(\.dismiss) private var dismiss
        
        @Environment(\.managedObjectContext) var moc
        
        @State var phone: String = ""
        
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
            Form {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                iPhoneNumberField("Phone", text: $phone)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .textContentType(.telephoneNumber)
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
            } footer: {
//                Button("Create Account", action: viewModel.submit)
//                    .font(.title3)
//                    .foregroundColor(.white)
//                    .frame(width: 200, height: 50)
//                    .background(.blue)
//                    .cornerRadius(50)
//                    .padding()
                
                
                Button("Create Account") {
                    
                    viewModel.submit()
                    
                    let activeUser = searchActiveUser()
                    activeUser?.isActive = false
                    
                    let user = User(context: moc)

                    user.name = $viewModel.name.wrappedValue
                    user.phone = phone
                    user.email = $viewModel.email.wrappedValue
                    user.password = $viewModel.password.wrappedValue
                    user.isActive = true
                    
                    
                        
                    do {
                        try moc.save()
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                .buttonStyle(.primary)
                
                Button("Sign In", action: dismiss.callAsFunction)
                    .font(.title3)

            }
            .alert("Cannot Create Account. Please enter a valid email", error: $viewModel.error)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)

        }
     
    }
    
}

private extension AuthView {
    struct SignInForm<Footer: View>: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        @Environment(\.managedObjectContext) var moc
        
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
        
        var body: some View {
            Form {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
            } footer: {
                Button("Sign In"){
                    viewModel.submit()
                    
                    let activeUser = searchActiveUser()
                    activeUser?.isActive = false
                
                    
                    let user =  search(email: $viewModel.email.wrappedValue, pwd: $viewModel.password.wrappedValue)
 
                    user?.isActive = true
                    
                }
                .buttonStyle(.primary)
            footer()
                .padding()
            }
            .alert("Enter valid credentials", error: $viewModel.error)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
            

        }
    }
}




private extension AuthView {
    struct Form<Fields: View, Footer: View>: View {
        @ViewBuilder let fields: () -> Fields
        @ViewBuilder let footer: () -> Footer

        var body: some View {
            VStack {
                Text("NewsCast")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                fields()
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                footer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

