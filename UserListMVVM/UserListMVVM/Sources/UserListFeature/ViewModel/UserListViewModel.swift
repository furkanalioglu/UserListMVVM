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
    internal var state: AnyPublisher<UserListViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let appRoot: CurrentValueSubject<Roots, Never>
    private let stateSubject = CurrentValueSubject<UserListViewState, Never>(.initial)
    private var cancellables = Set<AnyCancellable>()
    
    init(appRoot: CurrentValueSubject<Roots, Never>,
         users: [User]) {
        self.appRoot = appRoot
        self.users = users
        setupInitialState()
    }
    
    private func setupInitialState() {
        let viewModels = users.map { user in
            UserListTableCellViewModel(
                id: user.id,
                name: user.name,
                email: user.email
            )
        }
        stateSubject.send(.loaded(viewModels))
    }
}
