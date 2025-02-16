//
//  UserDetailViewModelTests.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 16.02.2025.
//

import XCTest
import Combine
@testable import UserListMVVM

final class UserDetailViewModelTests: XCTestCase {
    // MARK: - Properties
    private var disposeBag: Set<AnyCancellable>!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        disposeBag = []
    }
    
    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_InitialState_ShouldSetupCorrectSections() {
        // Given
        let mockUser = UserBuilder.buildMockUsers().first!
        let sut = UserDetailViewModel(user: mockUser)
        let expectation = expectation(description: "Should setup correct sections")
        
        sut.state
            .sink { state in
                if case let .loaded(sections) = state {
                    // Then
                    XCTAssertEqual(sections.count, 4, "Should have 4 sections")
                    
                    // Verify header section
                    if case let .header(headerViewModel) = sections[0] {
                        XCTAssertEqual(headerViewModel.name, mockUser.name)
                        XCTAssertEqual(headerViewModel.username, mockUser.username)
                    } else {
                        XCTFail("First section should be header")
                    }
                    
                    // Verify contact section
                    if case let .contact(contactViewModels) = sections[1] {
                        XCTAssertEqual(contactViewModels.count, 3)
                    } else {
                        XCTFail("Second section should be contact")
                    }
                    
                    // Verify address section
                    if case let .address(addressViewModels) = sections[2] {
                        XCTAssertEqual(addressViewModels.count, 3)
                    } else {
                        XCTFail("Third section should be address")
                    }
                    
                    // Verify company section
                    if case let .company(companyViewModels) = sections[3] {
                        XCTAssertEqual(companyViewModels.count, 3)
                    } else {
                        XCTFail("Fourth section should be company")
                    }
                    
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        
        // When
        sut.viewDidLoad()
        
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_FirState_ShouldBeInitial() {
        // Given
        let mockUser = UserBuilder.buildMockUsers().first!
        let sut = UserDetailViewModel(user: mockUser)
        
        sut.state
            .sink { state in
                XCTAssertEqual(state, UserDetailViewState.initial)
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        
        //Then
        //Nothing.
    }
    
    func test_AfterViewDidLoad_ShouldBeLoaded() {
        // Given
        let mockUser = UserBuilder.buildMockUsers().first!
        let sut = UserDetailViewModel(user: mockUser)
        let expectation = expectation(description: "Should be in loaded state")
        
        // When
        sut.state
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
            
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - Memory Management Tests
    func test_MemoryLeaks_ShouldNotOccur() {
        // Given
        weak var weakSut: UserDetailViewModel?
        
        autoreleasepool {
            let mockUser = UserBuilder.buildMockUsers().first!
            let sut = UserDetailViewModel(user: mockUser)
            weakSut = sut
            
            // When - Force a state update
            sut.viewDidLoad()
            _ = sut.state.sink { _ in }
        }
        
        // Then
        XCTAssertNil(weakSut, "ViewModel should be deallocated")
    }
}
