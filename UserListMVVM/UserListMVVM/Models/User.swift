//
//  User.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

public struct User: Codable {
   public let id: Int?
   public let name: String?
   public let username: String?
   public let email: String?
   public let address: Address?
   public let phone: String?
   public let website: String?
   public let company: Company?
    
    public init(id: Int? = nil,
                name: String? = nil,
                username: String? = nil,
                email: String? = nil,
                address: Address? = nil,
                phone: String? = nil,
                website: String? = nil,
                company: Company? = nil
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}

public struct Address: Codable, Hashable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

public struct Geo: Codable, Hashable {
    let lat: String?
    let lng: String?
}

public struct Company: Codable, Hashable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
}
