//
//  UserListViewModelTests.swift
//  UserListMVVM_Tests
//
//  Created by furkan on 16.02.2025.
//

import XCTest
import Combine
@testable import UserListMVVM

final class UserListViewModelTests: XCTestCase {
    // MARK: - Properties
    private var appRoot: CurrentValueSubject<Roots, Never>!
    private var disposeBag: Set<AnyCancellable>!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        disposeBag = []
    }
    
    override func tearDown() {
        appRoot = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_InitialState_WithEmptyUsers_ShouldShowEmptyList() {
        // Given
        appRoot = CurrentValueSubject<Roots, Never>(.userList(UserBuilder.buildEmptyUsers()))
        let sut = UserListViewModel(appRoot: appRoot, users: UserBuilder.buildEmptyUsers())
        let expectation = expectation(description: "Should show empty list")
        sut.state
            .sink { state in
                if case let .loaded(viewModels) = state {
                    XCTAssertTrue(viewModels.isEmpty)
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_InitialState_WithMockUsers_ShouldShowUserList() { //TODO: - Handle empty state
        // Given
        let mockUsers = UserBuilder.buildMockUsers()
        appRoot = CurrentValueSubject<Roots, Never>(.userList(mockUsers))
        let sut = UserListViewModel(appRoot: appRoot, users: mockUsers)
        let expectation = expectation(description: "Should show user list")
        
        sut.state
            .sink { state in
                if case let .loaded(viewModels) = state {
                    XCTAssertEqual(viewModels.count, mockUsers.count)
                    XCTAssertEqual(viewModels.first?.id, mockUsers.first?.id)
                    XCTAssertEqual(viewModels.first?.name, mockUsers.first?.name)
                    XCTAssertEqual(viewModels.first?.email, mockUsers.first?.email)
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - User Selection Tests
    func test_WhenUserSelected_ShouldTriggerUserDetailDestination() {
        // Given
        let mockUsers = UserBuilder.buildMockUsers()
        appRoot = CurrentValueSubject<Roots, Never>(.userList(mockUsers))
        let sut = UserListViewModel(appRoot: appRoot, users: mockUsers)
        let expectation = expectation(description: "Should trigger user detail")
        
        sut.destination
            .dropFirst()
            .sink { destination in
                if case let .userDetail(selectedUser) = destination {
                    XCTAssertEqual(selectedUser.id, mockUsers[0].id)
                    expectation.fulfill()
                }
            }
            .store(in: &disposeBag)
        
        // When
        sut.viewDidLoad()
        sut.didSelectRow(at: IndexPath(row: 0, section: 0))
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_WhenUserSelected_AndViewDidAppear_ShouldResetDestination() {
        // Given
        let mockUsers = UserBuilder.buildMockUsers()
        appRoot = CurrentValueSubject<Roots, Never>(.userList(mockUsers))
        let sut = UserListViewModel(appRoot: appRoot, users: mockUsers)
        let expectation = expectation(description: "Should follow correct navigation pattern")
        expectation.expectedFulfillmentCount = 3 // Initial nil + userDetail + final nil
        
        var destinationStates: [UserListDestinations?] = []
        sut.destination
            .sink { destination in
                destinationStates.append(destination)
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        
        // When - Simulate navigation flow
        sut.viewDidLoad()
        sut.viewDidAppear() // Initial appear - should stay nil
        sut.didSelectRow(at: IndexPath(row: 0, section: 0)) // Should set userDetail
        sut.viewDidAppear() // Should reset to nil
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(destinationStates.count, 3)
        XCTAssertNil(destinationStates[0], "Initial state should be nil")
        XCTAssertNotNil(destinationStates[1], "Second state should be userDetail")
        if case .userDetail(let user) = destinationStates[1] {
            XCTAssertEqual(user.id, mockUsers[0].id, "Selected user should match")
        } else {
            XCTFail("Second state should be userDetail")
        }
        XCTAssertNil(destinationStates[2], "Final state should be nil after viewDidAppear")
    }
    
    func test_WhenUserSelected_AndDestinationActive_ShouldPreventDoublePush() {

    }
    
    // MARK: - Memory Management Tests
    func test_MemoryLeaks_ShouldNotOccur() {
        // Given
        weak var weakSut: UserListViewModel?
        
        autoreleasepool {
            let mockUsers = UserBuilder.buildMockUsers()
            appRoot = CurrentValueSubject<Roots, Never>(.userList(mockUsers))
            let sut = UserListViewModel(appRoot: appRoot, users: mockUsers)
            weakSut = sut
            
            // When
            sut.viewDidLoad()
            sut.didSelectRow(at: IndexPath(row: 0, section: 0))
        }
        
        // Then
        XCTAssertNil(weakSut, "ViewModel should be deallocated")
    }
}
