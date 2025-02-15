//
//  UserListRootView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

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
    
    private var dataSource: DataSource?
    typealias DataSource = UITableViewDiffableDataSource<UserListSection, UserListTableCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UserListSection, UserListTableCellViewModel>

    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        constructHierarchy()
        setupDataSource()
    }
    
    private func setupViews() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.tableView)
    }
    
    private func constructHierarchy() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: { [weak self] tableView, indexPath, viewModel in
                guard self != nil else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(with: UserListTableCell.self, for: indexPath)
                return cell
            })
    }
}

extension UserListRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
