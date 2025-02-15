//
//  SplashViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Foundation
import Combine

protocol SplashViewModelDelegate: AnyObject {}

protocol SplashViewModelProtocol {
  // MARK: - Output
  var viewState: CurrentValueSubject<SplashViewState, Never> { get }
  var delegate: SplashViewModelDelegate? { get set }
  
  // MARK: - Input
  func tryAgainAction()
}

// MARK: - View State
enum SplashViewState: Equatable {
  case loading
  case error
}
