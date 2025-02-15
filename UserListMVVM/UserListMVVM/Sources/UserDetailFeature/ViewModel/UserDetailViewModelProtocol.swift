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
    case loaded([UserDetailSection])
    case error
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

struct UserDetailHeaderCellViewModel: Hashable {
    let id = UUID()
    let name: String
    let username: String
    
}

struct UserDetailInfoCellViewModel: Hashable {
    let id = UUID()
    let title: String
    let value: String
}

enum UserDetailCellViewModel: Hashable {
    case header(UserDetailHeaderCellViewModel)
    case info(UserDetailInfoCellViewModel)
} 
