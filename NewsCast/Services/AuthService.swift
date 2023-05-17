//
//  AuthService.swift
//  NewsCast
//
//  Created by Vignesh on 10/05/23.
//

import Foundation
import FirebaseAuth
import CoreData

@MainActor
class AuthService: ObservableObject {
    
    //@Published var isAuthenticated = false
    
    @Published var uzer: Uzer?

  


    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
//    init() {
//            listener = auth.addStateDidChangeListener { [weak self] _, user in
//                self?.isAuthenticated = user != nil
//            }
//        }
    
    init() {
        listener = auth.addStateDidChangeListener { [weak self] _, uzer in
            self?.uzer = uzer.map(Uzer.init(from:))
        }
    }
    
    func createAccount(name: String, email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.updateProfile(\.displayName, to: name)
        uzer?.name = name
    }
    
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func updateProfileImage(to imageFileURL: URL?) async throws {
        guard let uzer = auth.currentUser else {
            preconditionFailure("Cannot update profile for nil user")
        }
        guard let imageFileURL = imageFileURL else {
            try await uzer.updateProfile(\.photoURL, to: nil)
            if let photoURL = uzer.photoURL {
                try await StorageFile.atURL(photoURL).delete()
            }
            return
        }
        async let newPhotoURL = StorageFile
            .with(namespace: "users", identifier: uzer.uid)
            .putFile(from: imageFileURL)
            .getDownloadURL()
        try await uzer.updateProfile(\.photoURL, to: newPhotoURL)
    }
    

}

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}

private extension Uzer {
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? ""
        self.imageURL = firebaseUser.photoURL
    }
}
