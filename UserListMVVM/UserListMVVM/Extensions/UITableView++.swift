//
//  UITableView++.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit.UITableView

extension UITableView {

  // MARK: - Register Cell
  func registerCell<T: UITableViewCell>(cellType: T.Type) {
    let identifier = cellType.dequeuIdentifier
    register(cellType, forCellReuseIdentifier: identifier)
  }

  // MARK: - Dequeing
  func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withIdentifier: type.dequeuIdentifier, for: indexPath) as! T
  }
    
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
        ])
    }
}
