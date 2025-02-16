//
//  UserBuilder.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 15.02.2025.
//

import Foundation
@testable import UserListMVVM

enum UserBuilder {
    static func buildMockUsers() -> [User] {
        return [
            User(id: 1,
                 name: "John Doe",
                 username: "johndoe",
                 email: "john@example.com",
                 address: Address(street: "123 Main St",
                                suite: "Apt 4B",
                                city: "New York",
                                zipcode: "10001",
                                geo: Geo(lat: "40.7128",
                                        lng: "-74.0060")),
                 phone: "1-234-567-8900",
                 website: "johndoe.com",
                 company: Company(name: "Tech Corp",
                                catchPhrase: "Innovation First",
                                bs: "synergize scalable solutions")),
            User(id: 2,
                 name: "Jane Smith",
                 username: "janesmith",
                 email: "jane@example.com",
                 address: Address(street: "456 Oak St",
                                suite: "Unit 2A",
                                city: "Los Angeles",
                                zipcode: "90001",
                                geo: Geo(lat: "34.0522",
                                        lng: "-118.2437")),
                 phone: "1-234-567-8901",
                 website: "janesmith.com",
                 company: Company(name: "Design Co",
                                catchPhrase: "Design Excellence",
                                bs: "revolutionize user experience"))
        ]
    }
    
    static func buildEmptyUsers() -> [User] {
        return []
    }
} 
