//
//  ServiceProtocol.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}

protocol ServiceProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HttpMethod { get }
}

extension ServiceProtocol {
    public var urlRequest: URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        guard let url = components.url else {
            fatalError("Could not create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}
