//
//  SignUpView.swift
//  NewsCast
//
//  Created by Vignesh on 11/04/23.
//

import SwiftUI
import CoreData

struct SignUpView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss

    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var currentUser: String = ""
    @State var confirmPassword = ""
    @State var passwordVisible = false
    @State var confirmPasswordVisible = false
    //@Binding var show : Bool
    @State var alert = false
    @State var error = ""
    @State private var showingAlert = false
    
    @State var success: Bool = false
    
    var body: some View {
            VStack{
                Text("NewsCast")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Name", text: $name)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1)
                    )
                    .autocapitalization(.none)
                
//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding()
//                    .frame(width: 300, height: 50)
//                    .background(.black.opacity(0.05))
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(.white, lineWidth: 1)
//                    )
//                    .autocapitalization(.none)
//                
                
                NavigationLink(destination:
                                MainTabView(),
                               isActive: self.$success) {EmptyView()}.hidden()
                Button("Create Account") {
                    
                    let user = User(context: moc)

                    user.name = name
                    user.email = email
                    user.password = password
                    user.isActive = false
                    
                        
                    do {
                        try moc.save()
                        success = true
                    } catch {
                        success = false
                        showingAlert = true
                        print(error.localizedDescription)
                    }
                    
                }.font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .cornerRadius(50)
                    .padding()
                    .alert("A user with this email already exists", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                
                
                Button("Sign In", action: dismiss.callAsFunction)
                    .font(.title3)
                        
            }
            .navigationBarBackButtonHidden()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
