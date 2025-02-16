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
    // MARK: - Properties
    private var appRoot: CurrentValueSubject<Roots, Never>!
    private var disposeBag: Set<AnyCancellable>!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        appRoot = CurrentValueSubject<Roots, Never>(.splash)
        disposeBag = []
    }
    
    override func tearDown() {
        appRoot = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - General Tests
    func test_InitialState_ShouldBeInitial() {
        // Given
        let mockRepository = MockUserRepository()
        let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
        
        // When
        // Nothing
        
        // Then
        XCTAssertEqual(sut.viewState.value, .initial)
    }
    
    func test_WhenFetchUsersSucceeds_ShouldUpdateAppRoot() {
        // Given
        let mockRepository = MockUserRepository()
        let mockUsers = UserBuilder.buildMockUsers()
        mockRepository.result = mockUsers
        let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
        
        let expectation = expectation(description: "Should update app root")
        appRoot
            .receive(on: DispatchQueue.main)
            .sink { root in
                if case .userList(_) = root {
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
                
        // When
        sut.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    //MARK: - Error Handling Tests
    func test_WhenFetchUsersFails_ShouldShowError() {
        // Given
        let mockRepository = MockUserRepository()
        let networkError = NetworkError.serverError
        mockRepository.error = networkError
        let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
        
        let expectation = expectation(description: "Should show error")
        sut.viewState
            .dropFirst() // Skip initial .loading state
            .sink { state in
                if case let .error(message) = state {
                    XCTAssertEqual(message, networkError.errorDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
                    
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_WhenTryAgainActionCalled_ShouldRetryFetching() {
        // Given
        let mockRepository = MockUserRepository()
        
        //First request will fail
        let networkError = NetworkError.serverError
        mockRepository.error = networkError
        
        let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
        var stateChanges: [SplashViewState] = []
        let expectation = expectation(description: "Should complete state changes")
        
        sut.viewState
            .sink { state in
                stateChanges.append(state)
                if state == .error(networkError.errorDescription ?? "") {
                    //Then retry with success
                    mockRepository.error = nil
                    mockRepository.result = UserBuilder.buildMockUsers()
                    sut.tryAgainAction()
                }
                // When we receive loaded state after retry, fulfill expectation
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(stateChanges, [
            .initial,
            .loading,
            .error(networkError.errorDescription ?? ""),
            .loading,
            .loaded
        ])
        
        if case .userList(let users) = appRoot.value {
            XCTAssertFalse(users.isEmpty)
        } else {
            XCTFail("AppRoot should be .userList")
        }
    }
    
    func test_MultipleConsecutiveRetries_ShouldWorkCorrectly() {
        // Given
        let mockRepository = MockUserRepository()
        let networkError = NetworkError.serverError
        mockRepository.error = networkError
        let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
        
        let expectation = expectation(description: "Should handle multiple retries")
        var retryCount = 0
        
        sut.viewState
            .sink { state in
                if case .error = state {
                    retryCount += 1
                    if retryCount < 3 {
                        sut.tryAgainAction()
                    } else {
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(retryCount, 3)
    }
    
    //MARK: - Memory leak & Performance tests
    func test_CancellationOfRequests_WhenDeallocated() {
        // Given
        let mockRepository = MockUserRepository()
        mockRepository.delay = 1.0 // Simulate long running request
        
        autoreleasepool {
            let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
            sut.viewDidLoad()
        }
        
        // Then
        XCTAssertTrue(mockRepository.wasCancelled, "Request should be cancelled when view model is deallocated")
    }
    
    func test_MemoryLeaks_ShouldNotOccur() {
        // Given
        weak var weakSut: SplashViewModel?
        
        autoreleasepool {
            let mockRepository = MockUserRepository()
            let sut = SplashViewModel(appRoot: appRoot, repo: mockRepository)
            weakSut = sut
            
            // When
            sut.viewDidLoad()
        }
        
        // Then
        XCTAssertNil(weakSut, "ViewModel should be deallocated")
    }
    
    func test_ViewControllerMemoryLeaks_ShouldNotOccur() {
        // Given
        weak var weakController: SplashController?
        weak var weakViewModel: SplashViewModel?
        
        autoreleasepool {
            let mockRepository = MockUserRepository()
            let viewModel = SplashViewModel(appRoot: appRoot, repo: mockRepository)
            let controller = SplashController(viewModel: viewModel)
            weakController = controller
            weakViewModel = viewModel
            
            // When
            controller.loadViewIfNeeded()
            controller.viewDidLoad()
        }
        
        // Then
        XCTAssertNil(weakController, "Controller should be deallocated")
        XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
    }
    
    func test_RootViewMemoryLeaks_ShouldNotOccur() {
        // Given
        weak var weakView: SplashRootView?
        weak var weakViewModel: SplashViewModel?
        
        autoreleasepool {
            let mockRepository = MockUserRepository()
            let viewModel = SplashViewModel(appRoot: appRoot, repo: mockRepository)
            let view = SplashRootView(viewModel: viewModel)
            weakView = view
            weakViewModel = viewModel
            
            // When - Simulate view lifecycle
            view.layoutSubviews()
        }
        
        // Then
        XCTAssertNil(weakView, "Root view should be deallocated")
        XCTAssertNil(weakViewModel, "ViewModel should be deallocated")
    }
}
