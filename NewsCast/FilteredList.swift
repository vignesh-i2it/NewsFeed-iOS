//
//  FilteredList.swift
//  NewsCast
//
//  Created by Vignesh on 19/04/23.
//

import SwiftUI

struct FilteredList: View {
    
    @FetchRequest var fetchRequest: FetchedResults<User>
    
    var body: some View {
        List(fetchRequest) { user in
                Text("\(user.wrappedPassword)")
            }
    }
    
    init(email: String) {
        _fetchRequest = FetchRequest<User>(sortDescriptors: [], predicate: NSPredicate(format: "email == %@", email))
    }
}

    

