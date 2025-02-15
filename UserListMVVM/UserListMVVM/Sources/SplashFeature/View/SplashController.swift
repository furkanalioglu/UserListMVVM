//
//  SplashController.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class SplashController: NiblessViewController, SplashViewModelDelegate {
    // MARK: - Properties
    private let viewModel: SplashViewModelProtocol
    private let alertPresenter: AlertPresenting
    private var rootView: SplashRootView!
    private var disposeBag = Set<AnyCancellable>()
    
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.subscribe()
    }
    
    // MARK: - Methods
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func subscribe() {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleViewState(state)
            }
            .store(in: &disposeBag)
    }
    
    private func handleViewState(_ state: SplashViewState) {
        switch state {
        case .loading:
            break
        case .error:
            alertPresenter.showAlert(
                on: self,
                title: "Error",
                message: "Failed to load users. Please try again.",
                buttonTitle: "OK",
                action: { self.viewModel.tryAgainAction() }
            )
        }
    }
}
