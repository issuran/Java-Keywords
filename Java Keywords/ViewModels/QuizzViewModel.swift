//
//  QuizzViewModel.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 20/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class QuizzViewModel {
    let service = QuizzService()
    var keywordsModel: KeywordsModel!
    var serviceStatus: Observable<RequestStates<KeywordsModel, Error>> = Observable(.empty)
    
    init() { }
    
    func retrieveKeywords() {
        serviceStatus.value = .loading
        service.quizz() { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let keywords):
                sleep(5)
                self.keywordsModel = keywords ?? KeywordsModel()
                self.serviceStatus.value = .load(self.keywordsModel)
            case .failure(let error):
                self.serviceStatus.value = .error(error)
            case .empty:
                self.serviceStatus.value = .empty
            }
        }
    }
}
