//
//  NetworkError.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case missingURL
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingFailed(Error)
    case encodingFailed
    case unknown
    case underlying(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .missingURL:
            return "Missing URL"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .serverError:
            return "Server error"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .encodingFailed:
            return "Encoding failed"
        case .unknown:
            return "Unknown error"
        case .underlying(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
