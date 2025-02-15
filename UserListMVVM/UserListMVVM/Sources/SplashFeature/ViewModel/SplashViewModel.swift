//
//  SplashViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

final class SplashViewModel: SplashViewModelProtocol {
    // MARK: - Protocol Properties
    private(set) var viewState: CurrentValueSubject<SplashViewState, Never>
    weak var delegate: SplashViewModelDelegate?
    
    // MARK: - Private Properties
    private var disposeBag = Set<AnyCancellable>()
    private let appRoot: CurrentValueSubject<Roots, Never>
    private let service: UserServiceProtocol
    
    init(appRoot: CurrentValueSubject<Roots, Never>, 
         service: UserServiceProtocol = UserService()) {
        self.appRoot = appRoot
        self.service = service
        self.viewState = CurrentValueSubject<SplashViewState, Never>(.loading)
        self.fetchUsers()
    }
    
    private func fetchUsers() {
        viewState.value = .loading
        
        service.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.viewState.value = .error
                }
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.appRoot.send(.userList(users))
            }
            .store(in: &disposeBag)
    }
    
    internal func tryAgainAction() {
        self.fetchUsers()
    }
}
