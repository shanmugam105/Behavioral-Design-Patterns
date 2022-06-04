//
//  NetworkServiceHandler.swift
//  Network-Call-Practice
//
//  Created by ADMIN on 19/06/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import Foundation

protocol NetworkObservable {
    func updateResult()
    func updateError()
}

protocol NetworkObserver {
    var observers: [NetworkObservable] { get set }
    func addObserver(observer: NetworkObservable)
    func removeObserver(observer: NetworkObservable)
    func notifyObserver(with result: Result<Codable, Error>)
}

class NetworkServiceHandler: NSObject {
    static let shared = NetworkServiceHandler()
    private override init() {}
    var observers: [NetworkObservable] = []
    
    func request<T: Codable>(route: Route,
                             method: HTTPMethod = .GET,
                             parameter: [String: Any]? = nil,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        let request = createRequest(route: route, method: method, parameter: parameter)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                guard let result = try? JSONDecoder().decode(type, from: data) else{
                    return completion(.failure(LocalError.parsingError))
                }
                completion(.success(result))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(LocalError.unknownError))
            }
        }
        task.resume()
    }
    /// This function helps to create URLRequest
    /// - Parameters:
    ///   - route: Backend resource path
    ///   - method: Type of HTTP Request
    ///   - parameter: Need to pass to backend
    /// - Returns: It returns URLRequest
    private func createRequest(route: Route,
                               method: HTTPMethod = .GET,
                               parameter: [String: Any]? = nil) -> URLRequest {
        let urlString = Route.baseURL + route.description
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameter {
            switch method {
            case .GET:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map {URLQueryItem(name: $0, value: "\($1)")}
                
                urlRequest.url = urlComponent?.url
            case .POST, .DELETE, .PATCH:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}
