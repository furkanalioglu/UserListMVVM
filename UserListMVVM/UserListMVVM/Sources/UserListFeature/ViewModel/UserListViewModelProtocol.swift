//
//  UserListViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol UserListViewModelProtocol {
    var users: [User] { get }
    var state: AnyPublisher<UserListViewState, Never> { get }
    var destination: AnyPublisher<UserListDestinations?, Never> { get }
    func didSelectRow(at indexPath: IndexPath)
    func viewDidAppear()
}

enum UserListDestinations: Equatable {
    case userDetail(_ id: Int)
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
