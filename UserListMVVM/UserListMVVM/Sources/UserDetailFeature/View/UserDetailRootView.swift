//
//  UserDetailRootView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit
import Combine

final class UserDetailRootView: NiblessView {
    // MARK: - Properties
    private let viewModel: UserDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.registerCell(cellType: UserDetailHeaderCell.self)
        tableView.registerCell(cellType: UserDetailInfoCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()
    
    private var dataSource: DataSource?
    typealias DataSource = UITableViewDiffableDataSource<UserDetailSection, UserDetailCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UserDetailSection, UserDetailCellViewModel>
    
    // MARK: - Lifecycle
    init(viewModel: UserDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupDataSource()
        setupBindings()
    }
    
    // MARK: - Methods
    private func setupViews() {
        backgroundColor = .systemGroupedBackground
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, cellViewModel in
                guard self != nil else { return UITableViewCell() }
                
                switch cellViewModel {
                case .header(let viewModel):
                    let cell = tableView.dequeueReusableCell(with: UserDetailHeaderCell.self, for: indexPath)
                    cell.configure(with: viewModel)
                    return cell
                case .info(let viewModel):
                    let cell = tableView.dequeueReusableCell(with: UserDetailInfoCell.self, for: indexPath)
                    cell.configure(with: viewModel)
                    return cell
                }
            })
        
        dataSource?.defaultRowAnimation = .fade
    }
    
    private func setupBindings() {
        viewModel.state
            .sink { [weak self] state in
                debugPrint("State is",state)
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: UserDetailViewState) {
        switch state {
        case .loaded(let sections):
            var snapshot = Snapshot()
            snapshot.appendSections(sections)
            
            sections.forEach { section in
                switch section {
                case .header(let viewModel):
                    snapshot.appendItems([.header(viewModel)], toSection: section)
                case .contact(let viewModels),
                     .address(let viewModels),
                     .company(let viewModels):
                    let items = viewModels.map { UserDetailCellViewModel.info($0) }
                    snapshot.appendItems(items, toSection: section)
                }
            }
            
            dataSource?.apply(snapshot, animatingDifferences: false)
        default:
            break
        }
    }
} 
