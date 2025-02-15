//
//  BuildConfigurations.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

struct BuildConfiguration {
    
    init() {}

    func value(for key: ConfigurationFileKeys) -> String {
        guard let dictionary = Bundle.main.object(forInfoDictionaryKey: "CustomConfigurations") as? [String: String],
              let value = dictionary[key.plistKey]
        else {
            fatalError("Value not found for key: \(key.plistKey) in Configuration File")
        }
        
        return value.trimmingCharacters(in: .init(charactersIn: "\""))
    }
}

enum ConfigurationFileKeys: String {
    case baseURL
    
    var plistKey: String {
        switch self {
        case .baseURL:
            return "KEY_1"
        }
    }
}
