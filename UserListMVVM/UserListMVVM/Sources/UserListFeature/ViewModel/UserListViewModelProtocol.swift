//
//  UserListViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

protocol UserListViewModelDelegate: AnyObject {}

protocol UserListViewModelProtocol {
    var users: [User] { get }
    var delegate: UserListViewModelDelegate? { get set }
}

struct UserListTableCellViewModel: Hashable {
    let id: Int?
    let name: String?
    let email: String?
}

enum UserListSection: Hashable {
    case main
}
