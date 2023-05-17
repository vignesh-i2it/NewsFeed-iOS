//
//  Favorites+CoreDataProperties.swift
//  NewsCast
//
//  Created by Vignesh on 05/05/23.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var articleId: String?
    @NSManaged public var email: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var title: String?
    @NSManaged public var origin: User?
    
    public var wrappedArticleId: String {
        articleId ?? "Unknown"
    }
    
    public var wrappedEmail: String {
        email ?? "Unknown"
    }
    
    public var wrappedIsFavorite: Bool {
        isFavorite
    }
    
    public var wrappedUrl: String {
        url ?? "Unknown"
    }
    
    public var wrappedUrlToImage: String {
        urlToImage ?? "Unknown"
    }
    
    public var wrappedTitle: String {
        title ?? "Unknown"
    }
}

extension Favorites : Identifiable {

}
