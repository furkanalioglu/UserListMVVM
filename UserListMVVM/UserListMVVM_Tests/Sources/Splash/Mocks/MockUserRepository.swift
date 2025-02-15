//
//  MockUserRepository.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine
@testable import UserListMVVM

final class MockUserRepository: UserRepositoryProtocol {
    var fetchUsersResult: Result<[User], NetworkError> = .success([])
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        return fetchUsersResult.publisher
            .eraseToAnyPublisher()
    }
} 