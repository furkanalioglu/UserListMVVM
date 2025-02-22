//
//  SplashRootView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class SplashRootView: NiblessView {
    
    // MARK: - Properties
    private let viewModel: SplashViewModelProtocol
    private var disposeBag = Set<AnyCancellable>()
    
    private lazy var mainHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        return stack
    }()
    
    private lazy var mainVerticalStackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var appLogoImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var appLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.3.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "UserListMVVM"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemGray
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    init(viewModel: SplashViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        setupViews()
        constructHierarchy()
        subscribe()
    }
    
    // MARK: - Methods
    private func setupViews() {
        mainHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appLogoImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(mainHorizontalStackView)
        self.addSubview(activityIndicator)
        self.mainHorizontalStackView.addArrangedSubview(mainVerticalStackview)
        self.mainVerticalStackview.addArrangedSubview(self.appLogoImageContainerView)
        self.appLogoImageContainerView.addSubview(self.appLogoImageView)
        self.mainVerticalStackview.addArrangedSubview(self.appNameLabel)
    }
    
    private func constructHierarchy() {
        NSLayoutConstraint.activate([
            self.mainHorizontalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 12),
            self.mainHorizontalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -12),
            self.mainHorizontalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,constant: 12),
            self.mainHorizontalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -12),
            
            self.appLogoImageContainerView.heightAnchor.constraint(equalToConstant: 100),
            self.appLogoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.appLogoImageView.heightAnchor.constraint(equalToConstant: 100),
            self.appLogoImageView.centerXAnchor.constraint(equalTo: self.appLogoImageContainerView.centerXAnchor),
            self.appLogoImageView.centerYAnchor.constraint(equalTo: self.appLogoImageContainerView.centerYAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -12)
        ])
        self.appNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func subscribe() {
        viewModel.statePublisher
            .sink { [weak self] state in
                self?.handleActivityIndicatorState(state)
            }
            .store(in: &disposeBag)
    }
    
    private func handleActivityIndicatorState(_ state: SplashViewState) {
        switch state {
        case .initial, .loaded:
            self.activityIndicator.stopAnimating()
        case .loading:
            self.activityIndicator.startAnimating()
        case .error(_):
            break
        }
    }
}

