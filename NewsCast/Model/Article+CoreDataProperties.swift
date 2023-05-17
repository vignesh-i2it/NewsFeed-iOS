//
//  Article+CoreDataProperties.swift
//  NewsCast
//
//  Created by Vignesh on 05/05/23.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var publisedAt: String?
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    
    
}

extension Article : Identifiable {

}
