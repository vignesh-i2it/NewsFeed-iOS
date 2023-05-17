//
//  User+CoreDataProperties.swift
//  NewsCast
//
//  Created by Vignesh on 12/05/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var image: URL?
    @NSManaged public var favorite: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown"
    }
    
    public var wrappedEmail: String {
        email ?? "Unknown"
    }
    
    public var wrappedIsActive: Bool {
        isActive
    }
    
    public var wrappedPassword: String {
        password ?? "Unknown"
    }
    
    public var wrappedPhone: String {
        phone ?? "Unknown"
    }
    
    public var wrappedImage: URL {
        image ?? URL(string: "https://www.objc.io")!
    }
    
    
    public var favoriteArray: [Favorites] {
        let set = favorite as? Set<Favorites> ?? []
        return set.sorted {
                $0.wrappedTitle < $1.wrappedTitle
            }
    }

}

// MARK: Generated accessors for favorite
extension User {

    @objc(addFavoriteObject:)
    @NSManaged public func addToFavorite(_ value: Favorites)

    @objc(removeFavoriteObject:)
    @NSManaged public func removeFromFavorite(_ value: Favorites)

    @objc(addFavorite:)
    @NSManaged public func addToFavorite(_ values: NSSet)

    @objc(removeFavorite:)
    @NSManaged public func removeFromFavorite(_ values: NSSet)

}

extension User : Identifiable {

}
