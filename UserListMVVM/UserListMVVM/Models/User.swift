//
//  User.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let phone: String?
    let website: String?
    let address: Address?
    let company: Company?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Address: Codable, Hashable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo?
}

struct Geo: Codable, Hashable {
    let lat: String?
    let lng: String?
}

struct Company: Codable, Hashable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
} 
