//
//  UserDetailInfoCellViewModel.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct UserDetailInfoCellViewModel: Hashable {
    let id: UUID
    let title: String
    let value: String
    
    init(id: UUID = UUID(), title: String, value: String) {
        self.id = id
        self.title = title
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserDetailInfoCellViewModel, rhs: UserDetailInfoCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func createContactInfo(from user: User) -> [UserDetailInfoCellViewModel] {
        return [
            .init(title: "Email", value: user.email ?? "N/A"),
            .init(title: "Phone", value: user.phone ?? "N/A"),
            .init(title: "Website", value: user.website ?? "N/A")
        ]
    }
    
    static func createAddressInfo(from address: Address?) -> [UserDetailInfoCellViewModel] {
        guard let address = address else { return [] }
        return [
            .init(title: "Street", value: "\(address.street ?? ""), \(address.suite ?? "")"),
            .init(title: "City", value: address.city ?? "N/A"),
            .init(title: "Zipcode", value: address.zipcode ?? "N/A")
        ]
    }
    
    static func createCompanyInfo(from company: Company?) -> [UserDetailInfoCellViewModel] {
        guard let company = company else { return [] }
        return [
            .init(title: "Company", value: company.name ?? "N/A"),
            .init(title: "Catch Phrase", value: company.catchPhrase ?? "N/A"),
            .init(title: "Business", value: company.bs ?? "N/A")
        ]
    }
}
