//
//  UserDetailViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

final class UserDetailViewModel: UserDetailViewModelProtocol {
    private(set) var user: User
    weak var delegate: UserDetailViewModelDelegate?
    
    var state: AnyPublisher<UserDetailViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private let stateSubject = CurrentValueSubject<UserDetailViewState, Never>(.initial)
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        setupInitialState()
    }
    
    private func setupInitialState() {
        stateSubject.send(.loaded(user))
    }
} 
