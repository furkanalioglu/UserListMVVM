//
//  SplashViewModelTests.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 15.02.2025.
//

import XCTest
import Combine
@testable import UserListMVVM

final class SplashViewModelTests: XCTestCase {
    private var viewModel: SplashViewModelProtocol!
    private var mockRepository: MockUserRepository!
    private var appRoot: CurrentValueSubject<Roots, Never>!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        appRoot = CurrentValueSubject<Roots, Never>(.splash)
        cancellables = Set<AnyCancellable>()
        viewModel = SplashViewModel(appRoot: appRoot, repo: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        appRoot = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchUsers_whenFailed_shouldShowError() {
        // Given
        let expectedError = NetworkError.serverError
        mockRepository.fetchUsersResult = .failure(expectedError)
        
        // When
        let expectation = XCTestExpectation(description: "Should show error")
        
        viewModel.viewState
            .dropFirst()
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error, expectedError.errorDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchUsers()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
