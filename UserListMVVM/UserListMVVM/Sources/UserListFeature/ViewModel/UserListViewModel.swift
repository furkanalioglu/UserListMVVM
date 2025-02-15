//
//  UserListViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

final class UserListViewModel: UserListViewModelProtocol {
    // MARK: - Protocol Properties
    private(set) var users: [User]
    weak var delegate: UserListViewModelDelegate?
    
    // MARK: - Private Properties
    private let appRoot: CurrentValueSubject<Roots, Never>
    
    init(appRoot: CurrentValueSubject<Roots, Never>,
         users: [User]) {
        self.appRoot = appRoot
        self.users = users
    }
}
