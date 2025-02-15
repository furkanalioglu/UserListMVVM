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
