//
//  FetchUsersUseCaseMock.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 16.02.2025.
//

import Foundation
import Combine
@testable import UserListMVVM

public class FetchUsersUseCaseMock: FetchUsersUseCase {
    public var error: NetworkError?
    public var result: [User]?
    
    public init() { }
    
    public func execute() -> AnyPublisher<[User], NetworkError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let result = result {
            return Just(result)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        return Empty()
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
