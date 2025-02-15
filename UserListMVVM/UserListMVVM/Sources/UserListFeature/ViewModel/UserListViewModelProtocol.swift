//
//  UserListViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol UserListViewModelDelegate: AnyObject {}

protocol UserListViewModelProtocol {
    var users: [User] { get }
    var delegate: UserListViewModelDelegate? { get set }
    var state: AnyPublisher<UserListViewState, Never> { get }
}

enum UserListViewState {
    case initial
    case loading
    case loaded([UserListTableCellViewModel])
    case error
}

struct UserListTableCellViewModel: Hashable {
    let id: Int?
    let name: String?
    let email: String?
}

enum UserListSection: Hashable {
    case main
}
