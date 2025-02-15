//
//  UserDetailHeaderCellViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct UserDetailHeaderCellViewModel: Hashable {
    let id: Int
    let name: String
    let username: String
    
    init(user: User) {
        self.id = user.id ?? 0
        self.name = user.name ?? ""
        self.username = user.username ?? ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: UserDetailHeaderCellViewModel, rhs: UserDetailHeaderCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
