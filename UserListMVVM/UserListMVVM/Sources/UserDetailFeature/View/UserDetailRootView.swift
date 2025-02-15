//
//  UserDetailRootView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class UserDetailRootView: NiblessView {
    private let viewModel: UserDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray2
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        constructHierarchy()
        setupBindings()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        // Avatar constraints
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func constructHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Header setup
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        headerStack.addArrangedSubview(avatarImageView)
        headerStack.addArrangedSubview(nameLabel)
        headerStack.addArrangedSubview(usernameLabel)
        
        contentStackView.addArrangedSubview(createSpacerView(height: 24))
        contentStackView.addArrangedSubview(headerStack)
        contentStackView.addArrangedSubview(createSpacerView(height: 24))
        contentStackView.addArrangedSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupBindings() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: UserDetailViewState) {
        switch state {
        case .loaded(let user):
            configureUI(with: user)
        case .loading, .initial, .error:
            break
        }
    }
    
    private func configureUI(with user: User) {
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username ?? "")"
        
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Contact Information
        addInfoSection(title: "Contact Information", items: [
            ("Email", user.email ?? ""),
            ("Phone", user.phone ?? ""),
            ("Website", user.website ?? "")
        ])
        
        // Address
        addInfoSection(title: "Address", items: [
            ("Street", user.address?.street ?? ""),
            ("Suite", user.address?.suite ?? ""),
            ("City", user.address?.city ?? ""),
            ("Zipcode", user.address?.zipcode ?? "")
        ])
        
        // Company
        addInfoSection(title: "Company", items: [
            ("Name", user.company?.name ?? ""),
            ("Catch Phrase", user.company?.catchPhrase ?? ""),
            ("BS", user.company?.bs ?? "")
        ])
    }
    
    private func addInfoSection(title: String, items: [(String, String)]) {
        let sectionTitle = UILabel()
        sectionTitle.font = .systemFont(ofSize: 20, weight: .bold)
        sectionTitle.text = title
        
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        
        sectionStack.addArrangedSubview(sectionTitle)
        
        items.forEach { item in
            let itemStack = createInfoItemStack(title: item.0, value: item.1)
            sectionStack.addArrangedSubview(itemStack)
        }
        
        infoStackView.addArrangedSubview(sectionStack)
        infoStackView.addArrangedSubview(createSpacerView(height: 24))
    }
    
    private func createInfoItemStack(title: String, value: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textColor = .label
        valueLabel.text = value
        valueLabel.numberOfLines = 0
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
    private func createSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
} 
