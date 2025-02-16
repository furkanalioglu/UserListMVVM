//
//  FetchUsersUseCase.swift
//  UserListMVVM
//
//  Created by furkan on 16.02.2025.
//

import Foundation
import Combine

protocol FetchUsersUseCase {
    func execute() -> AnyPublisher<[User], NetworkError>
}

final class DefaultFetchUsersUseCase: FetchUsersUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute() -> AnyPublisher<[User], NetworkError> {
        return userRepository.fetchUsers()
    }
} 
