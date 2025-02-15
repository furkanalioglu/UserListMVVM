//
//  Router.swift
//  UserListMVVM
//
//  Created by furkan on 15.02.2025.
//

import Foundation
import Combine

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) -> AnyPublisher<Data, NetworkError>
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private let timeoutInterval: TimeInterval = 10.0
    private let networkQueue = DispatchQueue(label: "com.userlist.mvvm.example.UserListMVVM.networkQueue", qos: .userInitiated)
    private var task: URLSessionTask?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var session: URLSession = {
        return URLSession.shared
    }()
    
    func request(_ route: EndPoint) -> AnyPublisher<Data, NetworkError> {
        return Future<URLRequest, NetworkError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            do {
                let request = try self.buildRequest(from: route)
                NetworkLogger.log(request: request)
                promise(.success(request))
            } catch {
                promise(.failure(.invalidRequest))
            }
        }
        .receive(on: networkQueue)
        .flatMap { [weak self] request -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> in
            guard let self = self else { return Fail(error: NetworkError.unknown).eraseToAnyPublisher() }
            
            return self.session.dataTaskPublisher(for: request)
                .mapError { NetworkError.underlying($0) }
                .eraseToAnyPublisher()
        }
        .tryMap { result -> Data in
            NetworkLogger.log(response: result.response, data: result.data, error: nil)
            
            guard let httpResponse = result.response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return result.data
            case 400:
                throw NetworkError.badRequest
            case 401:
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
        }
        .mapError { error -> NetworkError in
            if let networkError = error as? NetworkError {
                return networkError
            }
            return NetworkError.underlying(error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func cancel() {
        self.task?.cancel()
        cancellables.removeAll()
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
                                  bodyParameters: bodyParameters,
                                  urlParameters: urlParameters)
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
