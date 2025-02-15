//
//  UserListTableCellViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct UserListTableCellViewModel: Hashable {
    let id: Int?
    let name: String?
    let email: String?
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserListTableCellViewModel, rhs: UserListTableCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
