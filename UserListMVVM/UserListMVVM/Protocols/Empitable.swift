//
//  Empitable.swift
//  UserListMVVM
//
//  Created by furkan on 16.02.2025.
//

import UIKit

public protocol Emptiable {
    
    func showEmptyView(with message: String?)
    
    func hideEmptyView()
}

// MARK: - UIViewController
public extension Emptiable where Self: UIView {
    
    func showEmptyView(with message: String?) {
        let emptyView = EmptyView()
        emptyView.messageLabel.text = message
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(emptyView)
        emptyView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        emptyView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        emptyView.tag = ConstansEmptiable.emptyViewTag
    }
    
    func hideEmptyView() {
        self.subviews.forEach { subView in
            if subView.tag == ConstansEmptiable.emptyViewTag {
                subView.removeFromSuperview()
            }
        }
    }
}

// MARK: - Constans Emptiable
private struct ConstansEmptiable {
    fileprivate static let emptyViewTag = 4321
}
