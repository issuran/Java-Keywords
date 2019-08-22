//
//  QuizzViewController.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 20/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class QuizzViewController: BaseViewController {
    
    var viewModel: QuizzViewModel!
    var flag: Bool = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var insertWordInput: CustomTextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: CustomButton!
    
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    convenience init(viewModel: QuizzViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        insertWordInput.isEnabled = false
        
        setObservables()
        
        viewModel.retrieveKeywords()
    }
    
    func setObservables() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel.serviceStatus.didChange = { [weak self] state in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch state {
                case .empty:
                    HUD.shared.hideLoading()
                    break
                case .loading:
                    HUD.shared.showLoading(self.view)
                    break
                case .load:
                    self.questionLabel.text = self.viewModel.keywordsModel?.question ?? "Wait"
                    self.pointsLabel.text = self.viewModel.scoreStatus.value
                    self.timerLabel.text = self.viewModel.timerStatus.value
                    self.headerView.isHidden = false
                    
                    HUD.shared.hideLoading()
                    self.tableView.reloadData()
                    break
                case .error(let error):
                    HUD.shared.hideLoading()
                    print("Error: \(error)")
                    break
                }
            }
        }
        
        viewModel.gameStatus.didChange = { [weak self] state in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch state {
                case .running:
                    self.tableView.isHidden = false
                    
                    self.insertWordInput.isEnabled = true
                    self.insertWordInput.becomeFirstResponder()
                    
                    self.startButton.setTitle("Reset", for: .normal)
                    break
                    
                case .stopped:
                    self.insertWordInput.text = ""
                    self.viewModel.stopGame()
                    self.tableView.reloadData()
                    
                    self.insertWordInput.isEnabled = false
                    self.insertWordInput.resignFirstResponder()
                    
                    self.startButton.setTitle("Start", for: .normal)
                    break
                    
                case .congratz:
                    self.viewModel.pauseGame()
                    self.alert(message: "Good job! You found all the answers on time. Keep up with the great work.",
                               title: "Congratulations",
                               buttonText: "Play Again",
                               completion: {
                                self.viewModel.gameStatus.value = .retry
                    })
                    break
                    
                case .failed:
                    self.viewModel.pauseGame()
                    self.alert(message: "Sorry, time is up! You got \(self.viewModel.matchedKeywords.count) out of \(self.viewModel.keywordsModel?.answer.count ?? 50) answers.",
                               title: "Time finished",
                               buttonText: "Try Again",
                               completion: {
                                self.viewModel.gameStatus.value = .retry
                    })
                    break
                    
                case .retry:
                    self.insertWordInput.text = ""
                    self.viewModel.restartGame()
                    self.tableView.reloadData()
                    break
                }
            }
        }
        
        viewModel.scoreStatus.didChange = { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pointsLabel.text = status
            }
        }
        
        viewModel.timerStatus.didChange = { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.timerLabel.text = status
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            footerBottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if footerView.frame.origin.y != 0 {
            footerBottomConstraint.constant = 0
        }
    }
    
    @IBAction func startResetGame(_ sender: Any) {
        viewModel.startResetGame()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        let keywordTyped = insertWordInput.text ?? ""
        if viewModel.matchedKeyword(keywordTyped) {
            insertWordInput.text = ""
            tableView.reloadData()
        }
    }
}
