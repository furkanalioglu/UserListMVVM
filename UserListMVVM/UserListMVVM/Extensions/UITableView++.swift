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
}
