//
//  NiblessView.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit

internal class NiblessView: UIView {
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Restricted Init
    @available(*, unavailable,
                message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
}
