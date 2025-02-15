//
//  UserService.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
    func fetchUsers() -> AnyPublisher<[User], NetworkError>
}

final class UserRepository: UserRepositoryProtocol {
    private let router: Router<UserAPI>
    
    init(router: Router<UserAPI> = Router<UserAPI>()) {
        self.router = router
    }
    
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
