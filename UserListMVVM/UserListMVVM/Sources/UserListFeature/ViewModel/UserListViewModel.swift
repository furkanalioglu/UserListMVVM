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
        stateSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    internal var destination: AnyPublisher<UserListDestinations?, Never> {
        destinationSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let appRoot: CurrentValueSubject<Roots, Never>
    private let stateSubject = CurrentValueSubject<UserListViewState, Never>(.initial)
    private let destinationSubject = CurrentValueSubject<UserListDestinations?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    private var isFirstAppear: Bool = true
    
    // MARK: - Lifecycle
    init(appRoot: CurrentValueSubject<Roots, Never>,
         users: [User]) {
        self.appRoot = appRoot
        self.users = users
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        setupInitialState()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        guard destinationSubject.value == nil else { return }
        destinationSubject.send(.userDetail(selectedUser))
    }
    
    func viewDidAppear() {
        if isFirstAppear {
            isFirstAppear = false
            return
        }
        
        destinationSubject.send(nil)
    }
    
    private func setupInitialState() {
        if users.isEmpty == false {
            let viewModels = users.map { user in
                UserListTableCellViewModel(
                    user: user
                )
            }
            stateSubject.send(.loaded(viewModels))
        }else{
            stateSubject.send(.empty)
        }
    }
}
