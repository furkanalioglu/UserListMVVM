//
//  UserDetailInfoCell.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

final class UserDetailInfoCell: NiblessTableViewCell {
    // MARK: - Properties
    private lazy var mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    // MARK: - Methods
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(titleLabel)
        mainVerticalStackView.addArrangedSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    func configure(with viewModel: UserDetailInfoCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
} 
