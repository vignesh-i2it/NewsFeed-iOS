//
//  User.swift
//  NewsCast
//
//  Created by Vignesh on 11/05/23.
//

import Foundation

struct Uzer: Identifiable, Equatable, Codable {
    var id: String
    var name: String
    var imageURL: URL?

}

extension Uzer {
    static let testUser = Uzer(
        id: "",
        name: "Jamie Harris",
        imageURL: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480")
    )
}

