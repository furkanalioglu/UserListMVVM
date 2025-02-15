//
//  UserAPI.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

enum UserAPI {
    case fetchUsers
}

extension UserAPI: EndPointType {    
    var path: String {
        switch self {
        case .fetchUsers:
            return "/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchUsers:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchUsers:
            return .request
        }
    }
}
