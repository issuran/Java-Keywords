//
//  QuizzService.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class QuizzService: ServiceProvider<API> {
    func quizz(completion: @escaping (Result<KeywordsModel?>) -> Void) {
        
        let provider = ServiceProvider<API>()
        
        provider.execute(service: .quizz) { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let model = try! decoder.decode(KeywordsModel.self, from: data)
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            case .empty:
                completion(.empty)
            }
        }
    }
}
