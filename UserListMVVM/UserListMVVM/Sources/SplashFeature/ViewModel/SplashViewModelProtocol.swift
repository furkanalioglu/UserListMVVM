//
//  SplashViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Foundation
import Combine

protocol SplashViewModelProtocol {
  // MARK: - Output
  var viewState: CurrentValueSubject<SplashViewState, Never> { get }
  
  // MARK: - Input
  func tryAgainAction()
  func fetchUsers()
}

// MARK: - View State
enum SplashViewState: Equatable {
  case loading
  case error(String)
}
