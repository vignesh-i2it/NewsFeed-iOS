//
//  NewsCastApp.swift
//  NewsCast
//
//  Created by Vignesh on 11/04/23.
//

import SwiftUI
import CoreData
import Firebase

//@main
//struct NewsCastApp: App {
//
//    @StateObject private var dataController = DataController()
//
//    var body: some Scene {
//        WindowGroup {
//
//
//            SignInView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)
//        }
//    }
//}


@main
struct NewsCastApp: App {
    
    @StateObject private var dataController = DataController()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
