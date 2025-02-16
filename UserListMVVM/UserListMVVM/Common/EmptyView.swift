//
//  EmptyView.swift
//  UserListMVVM
//
//  Created by furkan on 16.02.2025.
//

import Foundation
import UIKit

internal class EmptyView: NiblessView {
    lazy var mainHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    
    lazy var mainVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 30.0
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    public var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        constructHierarchy()
        activateConstraints()
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = .systemBackground
        imageView.image = UIImage(systemName: "person.circle.fill")
    }
    
    private func constructHierarchy() {
        addSubview(mainHorizontalStackView)
        mainHorizontalStackView.addArrangedSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(self.imageView)
        mainVerticalStackView.addArrangedSubview(self.messageLabel)
    }
    
    private func activateConstraints() {
        activateConstraintsForStackView()
    }
    
    private func activateConstraintsForStackView() {
        mainHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHorizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainHorizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainHorizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            mainHorizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
