//
//  UIView++.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit.UIView

extension UIView {
    
    /// Creates a spacer view with optional width and height constraints
    /// - Parameters:
    ///   - width: Optional constant width for the spacer
    ///   - height: Optional constant height for the spacer
    /// - Returns: A UIView configured as a spacer with the specified dimensions
    static func spacer(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return view
    }
    
    /// Creates a flexible spacer view that expands to fill available space
    /// - Returns: A UIView configured as a flexible spacer
    static func flexibleSpacer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }
}
