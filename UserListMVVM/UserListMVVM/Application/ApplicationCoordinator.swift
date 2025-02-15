//
//  ApplicationCoordinator.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

protocol Coordinator: AnyObject {
    func start()
}

enum Roots: Hashable {
    // Since we pass them in dictionary in childCoordinators, we need to conform to Hashable
    case splash
    case userList([User])
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .splash:
            hasher.combine("splash")
        case .userList:
            hasher.combine("userList")
        }
    }
    
    static func == (lhs: Roots, rhs: Roots) -> Bool {
        switch (lhs, rhs) {
        case (.splash, .splash):
            return true
        case let (.userList(lhsUsers), .userList(rhsUsers)):
            return lhsUsers.map { $0.id } == rhsUsers.map { $0.id }
        default:
            return false
        }
    }
}

class ApplicationCoordinator: Coordinator {
    
    private let window: UIWindow
    private var childCoordinators = [Roots: Coordinator]()
    
    private var appRoot = CurrentValueSubject<Roots, Never>(.splash)
    private var disposeBag = Set<AnyCancellable>()
    private let scheduler: DispatchQueue
    
    init(window: UIWindow,
         scheduler: DispatchQueue = .main) {
        self.window = window
        self.scheduler = scheduler
    }
    
    func start() {
        subscribeToRootChanges()
    }
    
    private func subscribeToRootChanges() {
        appRoot
            .receive(on: scheduler)
            .sink { [weak self] root in
                self?.transition(to: root)
            }
            .store(in: &disposeBag)
    }
    
    private func transition(to root: Roots) {
        switch root {
        case .splash:
            startSplashFlow()
        case .userList(let users):
            startUserListFlow(with: users)
        }
    }
    
    private func startSplashFlow() {
        self.childCoordinators.removeAll()
        let navigationController = UINavigationController()
        let viewModel = SplashViewModel(appRoot: appRoot)
        let splashController = SplashController(viewModel: viewModel)
        navigationController.setViewControllers([splashController], animated: false)
        setRootWithAnimation(navigationController)
    }
    
    private func startUserListFlow(with users: [User]) {
        self.childCoordinators.removeAll()
        let navigationController = UINavigationController()
        let viewModel = UserListViewModel(appRoot: appRoot, users: users)
        let userListController = UserListController(viewModel: viewModel)
        navigationController.setViewControllers([userListController], animated: false)
        setRootWithAnimation(navigationController)
    }
    
    private func setRootWithAnimation(_ controller: UIViewController) {
        self.window.rootViewController = controller
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: { _ in })
    }
    
    private func addChild(_ coordinator: Coordinator, for key: Roots) {
        childCoordinators[key] = coordinator
    }
    
    private func removeChild(for key: Roots) {
        childCoordinators.removeValue(forKey: key)
    }
}
