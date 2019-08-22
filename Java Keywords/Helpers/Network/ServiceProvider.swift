//
//  ServiceProvider.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class ServiceProvider<T: ServiceProtocol> {
    var urlSession = URLSession.shared
    
    init() { }
    
    func execute(service: T, completion: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: service.urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.empty)
            }
        }.resume()
    }
}
