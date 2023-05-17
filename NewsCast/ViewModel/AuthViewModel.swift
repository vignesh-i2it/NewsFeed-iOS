//
//  AuthViewModel.swift
//  NewsCast
//
//  Created by Vignesh on 18/04/23.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var uzer: Uzer?

//    @Published var email = ""
//    @Published var password = ""
 
    private let authService = AuthService()
 
    init() {
        authService.$uzer.assign(to: &$uzer)
    }
    
//    func signIn() {
//        Task {
//            do {
//                try await authService.signIn(email: email, password: password)
//            } catch {
//                print("[AuthViewModel] Cannot sign in: \(error)")
//            }
//        }
//    }
    func makeViewModelFactory() -> ViewModelFactory? {
        guard let uzer = uzer else {
            return nil
        }
        return ViewModelFactory(uzer: uzer, authService: authService)
    }
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }
     
    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name:email:password:))
    }
    
}

extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
 
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
