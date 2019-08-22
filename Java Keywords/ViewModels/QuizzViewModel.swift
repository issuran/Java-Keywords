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
    var timerStatus = Observable(String())
    
    var matchedKeywords = [String]()
    
    var timer: Timer!
    var timeLeft = 300
    
    init() { }
    
    // GAME
    
    func startResetGame() {
        gameStatus.value = (gameStatus.value == .running || gameStatus.value == .retry)
            ? .stopped
            : .running
        
        switch gameStatus.value {
        case .running:
            startTimer()
        case .stopped, .congratz, .failed, .retry:
            stopTimer()
        }
    }
    
    func pauseGame() {
        pauseTimer()
    }
    
    func restartGame() {
        matchedKeywords = [String]()
        restartTimer()
        scoreStatus.value = "00/00"
        timerStatus.value = "00:00"
    }
    
    func stopGame() {
        matchedKeywords = [String]()
        stopTimer()
        scoreStatus.value = "00/00"
        timerStatus.value = "00:00"
    }
    
    // TIMER
    
    func currentTimer() {
        timerStatus.value = "\(minutes()):\(seconds())"
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeLeft = 300
        timerStatus.value = "00:00"
    }
    
    func restartTimer() {
        stopTimer()
        startTimer()
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timerStatus.value = "\(minutes()):\(seconds())"
        
        if timeLeft <= 0 {
            gameStatus.value = .failed
            timer.invalidate()
            timer = nil
        }
    }
    
    func minutes() -> String {
        let minutes = (timeLeft % 3600) / 60
        if minutes < 10 {
            return ("0\(minutes)")
        }
        return "\(minutes)"
    }
    
    func seconds() -> String {
        let seconds = (timeLeft % 3600) % 60
        if seconds < 10 {
            return ("0\(seconds)")
        }
        return "\(seconds)"
    }
    
    // CHECK MATCHES
    
    func matchedKeyword(_ keyword: String) -> Bool {
        if keywordsModel!.answer.contains(keyword)
            && !matchedKeywords.contains(keyword.capitalized) {
            matchedKeywords.append(keyword.capitalized)
            updateScore()
            checkDone()
            return true
        }
        return false
    }
    
    func updateScore() {
        guard let answers = keywordsModel else {
            scoreStatus.value = "00/00"
            return
        }
        let matches = matchedKeywords.count < 10 ? "0\(matchedKeywords.count)" : "\(matchedKeywords.count)"
        let total = answers.answer.count < 10 ? "0\(answers.answer.count)" : "\(answers.answer.count)"
        
        let scoreLayout = "\(matches)/\(total)"
        scoreStatus.value = scoreLayout
    }
    
    func retrieveKeywords() {
        serviceStatus.value = .loading
        service.quizz() { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let keywords):
                self.keywordsModel = keywords ?? KeywordsModel()
                self.updateScore()
                self.currentTimer()
                self.serviceStatus.value = .load(self.keywordsModel!)
            case .failure(let error):
                self.serviceStatus.value = .error(error)
            case .empty:
                self.serviceStatus.value = .empty
            }
        }
    }
    
    func checkDone() {
        guard let keywordsModel = keywordsModel else { return }
        
        if matchedKeywords.count == keywordsModel.answer.count {
            gameStatus.value = .congratz
        }
    }
    
    func numberOfRows() -> Int {
        return matchedKeywords.count
    }
}
