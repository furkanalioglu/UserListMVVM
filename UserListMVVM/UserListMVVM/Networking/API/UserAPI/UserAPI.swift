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
    var baseURL: URL {
        let urlString = BuildConfiguration().value(for: .baseURL)
        guard let url = URL(string: "https://" + urlString) else {
            debugPrint("URL is",urlString)
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
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
