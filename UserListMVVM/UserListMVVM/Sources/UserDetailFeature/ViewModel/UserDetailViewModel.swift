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
    weak var delegate: UserDetailViewModelDelegate?
    
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
        let headerViewModel = UserDetailHeaderCellViewModel(
            name: user.name ?? "",
            username: user.username ?? ""
        )
        sections.append(.header(headerViewModel))
        
        // Contact Section
        let contactViewModels = [
            UserDetailInfoCellViewModel(title: "Email", value: user.email ?? ""),
            UserDetailInfoCellViewModel(title: "Phone", value: user.phone ?? ""),
            UserDetailInfoCellViewModel(title: "Website", value: user.website ?? "")
        ]
        sections.append(.contact(contactViewModels))
        
        // Address Section
        let addressViewModels = [
            UserDetailInfoCellViewModel(title: "Street", value: user.address?.street ?? ""),
            UserDetailInfoCellViewModel(title: "Suite", value: user.address?.suite ?? ""),
            UserDetailInfoCellViewModel(title: "City", value: user.address?.city ?? ""),
            UserDetailInfoCellViewModel(title: "Zipcode", value: user.address?.zipcode ?? "")
        ]
        sections.append(.address(addressViewModels))
        
        // Company Section
        let companyViewModels = [
            UserDetailInfoCellViewModel(title: "Name", value: user.company?.name ?? ""),
            UserDetailInfoCellViewModel(title: "Catch Phrase", value: user.company?.catchPhrase ?? ""),
            UserDetailInfoCellViewModel(title: "BS", value: user.company?.bs ?? "")
        ]
        sections.append(.company(companyViewModels))
        
        stateSubject.send(.loaded(sections))
    }
} 
