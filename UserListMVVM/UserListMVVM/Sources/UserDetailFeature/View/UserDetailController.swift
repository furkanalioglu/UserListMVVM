//
//  UserDetailController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

final class UserDetailController: NiblessViewController, UserDetailViewModelDelegate {
    private let viewModel: UserDetailViewModelProtocol
    private var rootView: UserDetailRootView!
    
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        rootView = UserDetailRootView(viewModel: viewModel)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "\(viewModel.user.name ?? "")"
        navigationItem.largeTitleDisplayMode = .never
    }
} 
