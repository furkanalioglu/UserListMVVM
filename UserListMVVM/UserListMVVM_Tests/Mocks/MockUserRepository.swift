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
    var result: [User]?
    var error: NetworkError?
    var delay: TimeInterval = 0
    private(set) var wasCancelled = false
    private var cancellable: AnyCancellable?
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
        if let error = error {
            return Fail(error: error)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .handleEvents(receiveCancel: { [weak self] in
                    self?.wasCancelled = true
                })
                .eraseToAnyPublisher()
        }
        
        if let result = result {
            return Just(result)
                .setFailureType(to: NetworkError.self)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .handleEvents(receiveCancel: { [weak self] in
                    self?.wasCancelled = true
                })
                .eraseToAnyPublisher()
        }
        
        return Empty()
            .setFailureType(to: NetworkError.self)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .handleEvents(receiveCancel: { [weak self] in
                self?.wasCancelled = true
            })
            .eraseToAnyPublisher()
    }
} 
