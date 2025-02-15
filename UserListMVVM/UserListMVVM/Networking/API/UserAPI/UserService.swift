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
    private let router = Router<UserAPI>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        return router.request(.fetchUsers)
            .decode(type: [User].self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.decodingFailed(error)
            }
            .eraseToAnyPublisher()
    }
}
