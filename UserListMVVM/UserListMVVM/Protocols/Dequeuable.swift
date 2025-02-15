//
//  Dequeuable.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import UIKit.UITableViewCell

public protocol Dequeuable {
  static var dequeuIdentifier: String { get }
}

extension Dequeuable where Self: UIView {
  public static var dequeuIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: Dequeuable { }
