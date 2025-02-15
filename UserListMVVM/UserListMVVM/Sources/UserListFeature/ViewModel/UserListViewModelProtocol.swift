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

enum UserListDestinations {
    case userDetail(_ user: User)
}

enum UserListViewState {
    case initial
    case loading
    case loaded([UserListTableCellViewModel])
    case error
}

enum UserListSection: Hashable {
    case main
}
