//
//  EndpointType.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

internal protocol EndPointType: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

extension EndPointType {
    var baseURL: URL {
        let urlString = BuildConfiguration().value(for: .baseURL)
        guard let url = URL(string: "https://" + urlString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
}
