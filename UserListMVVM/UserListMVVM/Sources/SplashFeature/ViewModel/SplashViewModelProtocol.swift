//
//  SplashViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol SplashViewModelProtocol {
  // MARK: - Output
  var statePublisher: AnyPublisher<SplashViewState, Never> { get }
  
  // MARK: - Input
  func viewDidLoad()
  func tryAgainAction()
  func handleLoadedState()
}

// MARK: - View State
enum SplashViewState: Equatable {
  case initial
  case loading
  case error(String)
  case loaded
}
