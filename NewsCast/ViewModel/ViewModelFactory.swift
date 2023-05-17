//
//  ViewModelFactory.swift
//  NewsCast
//
//  Created by Vignesh on 11/05/23.
//

import Foundation

@MainActor
class ViewModelFactory: ObservableObject {
    private let uzer: Uzer
    private let authService: AuthService
 
    init(uzer: Uzer, authService: AuthService) {
        self.uzer = uzer
        self.authService = authService
    }

    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(uzer: uzer, authService: authService)
    }
 

    
    
    
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(uzer: Uzer.testUser, authService: AuthService())
}
#endif
