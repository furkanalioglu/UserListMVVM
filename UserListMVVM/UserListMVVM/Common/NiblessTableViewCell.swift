//
//  NiblessTableViewCell.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

open class NiblessTableViewCell: UITableViewCell {
    
    // MARK: - Methods
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Restricted Init
    @available(*, unavailable,
                message: "Loading this view Cell from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder: NSCoder) {
        fatalError("Loading this view Cell from a nib is unsupported in favor of initializer dependency injection.")
    }
}
