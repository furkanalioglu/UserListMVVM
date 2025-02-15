//
//  UserService.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    func fetchUsers() -> AnyPublisher<[User], NetworkError>
}

final class UserService: UserServiceProtocol {
    private let networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        let endpoint = UserAPI.fetchUsers
        return networking.request(endpoint)
    }
}
