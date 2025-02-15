//
//  UserListController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

final class UserListController: NiblessViewController, UserListViewModelDelegate {
    // MARK: - Properties
    private let viewModel: UserListViewModelProtocol
    private var rootView: UserListRootView!
    
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
    }
    
    private func setupNavigationBar() {
        title = "Users"
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
