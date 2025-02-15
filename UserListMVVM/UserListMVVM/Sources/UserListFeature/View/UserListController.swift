//
//  UserListController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class UserListController: NiblessViewController {
    // MARK: - Properties
    private let viewModel: UserListViewModelProtocol
    private var rootView: UserListRootView!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        rootView = UserListRootView(viewModel: viewModel)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        subscribe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }
    
    private func setupNavigationBar() {
        title = "Users"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func subscribe() {
        viewModel.destination
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] destination in
                guard let self else { return }
                self.handleDestination(destination)
            }
            .store(in: &cancellables)
    }
    
    private func handleDestination(_ destination: UserListDestinations?) {
        guard let destination = destination else { return }
        
        switch destination {
        case .userDetail(let userId):
            let user = self.viewModel.users.first { $0.id == userId }
            let detailViewModel = UserDetailViewModel(user: user!)
            let detailController = UserDetailController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
