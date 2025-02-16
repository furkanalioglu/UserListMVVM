import Foundation
import Combine
@testable import UserListMVVM

final class MockUserRepository: UserRepositoryProtocol {
    var result: [User]?
    var error: NetworkError?
    
    func fetchUsers() -> AnyPublisher<[User], NetworkError> {
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
