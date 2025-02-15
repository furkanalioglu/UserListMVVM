//
//  User.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
} 