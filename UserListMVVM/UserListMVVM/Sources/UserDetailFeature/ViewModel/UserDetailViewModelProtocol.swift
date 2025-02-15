//
//  UserDetailViewModelProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol UserDetailViewModelDelegate: AnyObject {}

protocol UserDetailViewModelProtocol {
    var user: User { get }
    var delegate: UserDetailViewModelDelegate? { get set }
    var state: AnyPublisher<UserDetailViewState, Never> { get }
}

enum UserDetailViewState {
    case initial
    case loading
    case loaded(User)
    case error
} 
