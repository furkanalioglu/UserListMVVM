//
//  NetworkLogger.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation

final class NetworkLogger {
    static func log(request: URLRequest) {
        #if DEBUG
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        if let body = request.httpBody {
            logOutput += "\n \(String(data: body, encoding: .utf8) ?? "")"
        }
        
        print(logOutput)
        #endif
    }
    
    static func log(response: URLResponse?, data: Data?, error: Error?) {
        #if DEBUG
        print("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        print("Status Code: \(statusCode ?? 0)")
        
        if let data = data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                print("Response: \(json)")
            }
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        #endif
    }
}
