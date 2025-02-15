//
//  UserListTableCell.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

final class UserListTableCell: NiblessTableViewCell {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none        
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(nameLabel)
        containerStackView.addArrangedSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    func configure(with viewModel: UserListTableCellViewModel) {
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        emailLabel.text = nil
    }
}
