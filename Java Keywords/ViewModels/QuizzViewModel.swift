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
    var keywordsModel: KeywordsModel?
    var serviceStatus: Observable<RequestStates<KeywordsModel, Error>> = Observable(.empty)
    var gameStatus = Observable(GameStatus.stopped)
    var scoreStatus = Observable(String())
    
    var matchedKeywords = [String]()
    
    init() { }
    
    func startResetGame() {
        gameStatus.value = (gameStatus.value == .running || gameStatus.value == .retry)
            ? .stopped
            : .running
    }
    
    func retrieveKeywords() {
        serviceStatus.value = .loading
        service.quizz() { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let keywords):
                sleep(1)
                self.keywordsModel = keywords ?? KeywordsModel()
                self.serviceStatus.value = .load(self.keywordsModel!)
            case .failure(let error):
                self.serviceStatus.value = .error(error)
            case .empty:
                self.serviceStatus.value = .empty
            }
        }
    }
    
    func restartGame() {
        matchedKeywords = [String]()
        scoreStatus.value = "00/00"
    }
    
    func matchedKeyword(_ keyword: String) -> Bool {
        if keywordsModel!.answer.contains(keyword)
            && !matchedKeywords.contains(keyword) {
            matchedKeywords.append(keyword)
            updateScore()
            checkDone()
            return true
        }
        return false
    }
    
    func updateScore() {
        let scoreLayout = "\(matchedKeywords.count)/\(keywordsModel?.answer.count ?? 00)"
        scoreStatus.value = scoreLayout
    }
    
    func checkDone() {
        if matchedKeywords.count == 3 {
            gameStatus.value = .congratz
        }
    }
    
    func numberOfRows() -> Int {
        return matchedKeywords.count
    }
}
