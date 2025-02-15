//
//  UserListRootView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class UserListRootView: NiblessView {
    private let viewModel: UserListViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.registerCell(cellType: UserListTableCell.self)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var dataSource: DataSource?
    typealias DataSource = UITableViewDiffableDataSource<UserListSection, UserListTableCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UserListSection, UserListTableCellViewModel>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        constructHierarchy()
        setupDataSource()
        setupBindings()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addSubview(loadingIndicator)
    }
    
    private func constructHierarchy() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
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
    
    private func handleState(_ state: UserListViewState) {
        switch state {
        case .initial:
            tableView.isHidden = true
            loadingIndicator.stopAnimating()
        case .loading:
            tableView.isHidden = true
            loadingIndicator.startAnimating()
        case .loaded(let viewModels):
            tableView.isHidden = false
            loadingIndicator.stopAnimating()
            updateDataSource(with: viewModels)
        case .error:
            tableView.isHidden = true
            loadingIndicator.stopAnimating()
        }
    }
    
    private func updateDataSource(with viewModels: [UserListTableCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, viewModel in
                guard self != nil else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(with: UserListTableCell.self, for: indexPath)
                cell.configure(with: viewModel)
                return cell
            })
    }
}

extension UserListRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
