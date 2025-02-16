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
    var state: AnyPublisher<UserDetailViewState, Never> { get }
    
    func viewDidLoad()
}

enum UserDetailViewState: Equatable {
    case initial
    case loaded([UserDetailSection])
    
    static func == (lhs: UserDetailViewState, rhs: UserDetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case let (.loaded(lhsSections), .loaded(rhsSections)):
            return lhsSections == rhsSections
        default:
            return false
        }
    }
}

enum UserDetailSection: Hashable {
    case header(UserDetailHeaderCellViewModel)
    case contact([UserDetailInfoCellViewModel])
    case address([UserDetailInfoCellViewModel])
    case company([UserDetailInfoCellViewModel])
    
    var title: String {
        switch self {
        case .header: return ""
        case .contact: return "Contact Information"
        case .address: return "Address"
        case .company: return "Company"
        }
    }
}

enum UserDetailCellViewModel: Hashable {
    case header(UserDetailHeaderCellViewModel)
    case info(UserDetailInfoCellViewModel)
} 
