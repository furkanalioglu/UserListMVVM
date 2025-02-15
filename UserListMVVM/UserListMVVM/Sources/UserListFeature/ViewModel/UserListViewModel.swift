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
    
    internal var state: AnyPublisher<UserListViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    internal var destination: AnyPublisher<UserListDestinations?, Never> {
        destinationSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let appRoot: CurrentValueSubject<Roots, Never>
    private let stateSubject = CurrentValueSubject<UserListViewState, Never>(.initial)
    private let destinationSubject = CurrentValueSubject<UserListDestinations?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    private var isFirstAppear: Bool = true
    
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
    
    func didSelectRow(at indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        guard let id = selectedUser.id else { return }
        destinationSubject.send(.userDetail(id))
    }
    
    func viewDidAppear() {
        if isFirstAppear {
            isFirstAppear = false
            return
        }
        
        destinationSubject.send(nil)
    }
}
