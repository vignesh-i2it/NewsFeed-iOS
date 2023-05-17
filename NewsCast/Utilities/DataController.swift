//
//  DataController.swift
//  NewsCast
//
//  Created by Vignesh on 11/04/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "NewsCast")
    
    init() {
        container.loadPersistentStores { description, error in
            print(NSTemporaryDirectory())
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            //self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
        }
    }
}

