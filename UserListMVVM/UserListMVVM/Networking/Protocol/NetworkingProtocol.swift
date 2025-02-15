//
//  NetworkingProtocol.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol NetworkingProtocol {
    func request<T: Decodable>(_ endpoint: EndPointType) -> AnyPublisher<T, NetworkError>
    func request(_ endpoint: EndPointType) -> AnyPublisher<Data, NetworkError>
} 