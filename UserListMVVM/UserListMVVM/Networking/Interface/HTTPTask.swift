//
//  HTTPTask.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

internal typealias HTTPHeaders = [String:String]

internal enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload... etc
}
