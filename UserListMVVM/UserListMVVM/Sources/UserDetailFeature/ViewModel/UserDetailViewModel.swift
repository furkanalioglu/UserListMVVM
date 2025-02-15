//
//  UserDetailViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

final class UserDetailViewModel: UserDetailViewModelProtocol {
    private(set) var user: User
    
    var state: AnyPublisher<UserDetailViewState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private let stateSubject = CurrentValueSubject<UserDetailViewState, Never>(.initial)
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        setupInitialState()
    }
    
    private func setupInitialState() {
        var sections: [UserDetailSection] = []
        
        // Header Section
        sections.append(.header(UserDetailHeaderCellViewModel(user: user)))
        // Contact Section
        sections.append(.contact(UserDetailInfoCellViewModel.createContactInfo(from: user)))
        // Address Section
        sections.append(.address(UserDetailInfoCellViewModel.createAddressInfo(from: user.address)))
        // Company Section
        sections.append(.company(UserDetailInfoCellViewModel.createCompanyInfo(from: user.company)))
        
        stateSubject.send(.loaded(sections))
    }
} 
