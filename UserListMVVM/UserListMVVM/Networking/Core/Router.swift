//
//  Router.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public struct NetworkRouterCompletionWrapper {
    public let completion: NetworkRouterCompletion
    
    public init(completion: @escaping NetworkRouterCompletion) {
        self.completion = completion
    }
}

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private let timeoutInterval: TimeInterval = 10.0
    private let networkQueue = DispatchQueue(label: "com.userlist.mvvm.example.UserListMVVM.networkQueue", qos: .userInitiated)
    private let networkResponseQueue = DispatchQueue.main
    private var task: URLSessionTask?
    
    private lazy var session: URLSession = {
        // Shared URLSession instance for handling network requests.
        // Replace line below with the MTLS configuration if needed.
        return URLSession.shared
    }()
    
    internal func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        networkQueue.async { [weak self] in
            guard let self = self else { return }
            do {
                let request = try self.buildRequest(from: route)
                self.task = self.session.dataTask(with: request, completionHandler: { data, response, error in
                    self.networkResponseQueue.async { [weak self] in
                        guard self != nil else { return }
                        completion(data, response, error)
                    }
                })
                self.task?.resume()
            } catch {
                self.networkResponseQueue.async { [weak self] in
                    guard self != nil else { return }
                    completion(nil, nil, error)
                }
            }
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: self.timeoutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                               let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
