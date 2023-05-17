//
//  ProfileViewModel.swift
//  NewsCast
//
//  Created by Vignesh on 25/04/23.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject, StateManager {
    
    @Published var name: String
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    @Published var error: Error?
    @Published var isWorking = false

    
    private let authService: AuthService

    init(uzer: Uzer, authService: AuthService) {
        self.name = uzer.name
        self.imageURL = uzer.imageURL
        self.authService = authService
    }
    
    func signOut() {
        withStateManagingTask(perform: authService.signOut)
    }
    
    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withStateManagingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}

