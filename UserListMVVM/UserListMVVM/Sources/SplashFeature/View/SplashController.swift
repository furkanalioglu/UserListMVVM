//
//  SplashController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class SplashController: NiblessViewController {
    // MARK: - Properties
    private let viewModel: SplashViewModelProtocol
    private let alertPresenter: AlertPresenting
    private var rootView: SplashRootView!
    private var disposeBag = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init(viewModel: SplashViewModelProtocol, 
         alertPresenter: AlertPresenting = AlertPresenter()) {
        self.viewModel = viewModel
        self.alertPresenter = alertPresenter
        super.init()
    }
    
    override func loadView() {
        rootView = SplashRootView(viewModel: viewModel)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.subscribe()
        self.viewModel.viewDidLoad()
    }
    
    // MARK: - Methods
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func subscribe() {
        viewModel.statePublisher
            .sink { [weak self] state in
                self?.handleViewState(state)
            }
            .store(in: &disposeBag)
    }
    
    private func handleViewState(_ state: SplashViewState) {
        switch state {
        case .initial, .loaded, .loading:
            break
        case .error(let error):
            alertPresenter.showAlert(
                on: self,
                title: "Error",
                message: error,
                buttonTitle: "OK",
                action: { self.viewModel.tryAgainAction() }
            )
        }
    }
}
