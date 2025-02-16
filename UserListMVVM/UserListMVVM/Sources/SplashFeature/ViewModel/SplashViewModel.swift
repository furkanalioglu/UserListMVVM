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
    private var viewState = CurrentValueSubject<SplashViewState, Never>(.initial)
    
    var statePublisher: AnyPublisher<SplashViewState, Never> {
        viewState
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    // MARK: - Private Properties
    private var disposeBag = Set<AnyCancellable>()
    private let appRoot: CurrentValueSubject<Roots, Never>
    private let repo: UserRepositoryProtocol
    private var users: [User] = []
    
    // MARK: - Lifecycle
    init(appRoot: CurrentValueSubject<Roots, Never>,
         repo: UserRepositoryProtocol = UserRepository()) {
        self.appRoot = appRoot
        self.repo = repo
    }
    
    // MARK: - Methods
    internal func tryAgainAction() {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        viewState.value = .loading
        
        repo.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.viewState.value = .error(
                        error.errorDescription ??
                        error.localizedDescription
                    )
                }
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.users = users
                self.viewState.value = .loaded
                self.handleLoadedState()
            }
            .store(in: &disposeBag)
    }
    
    func handleLoadedState() {
        self.appRoot.send(.userList(self.users))
    }
    
    func viewDidLoad() {
        self.fetchUsers()
    }
}
