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
        
        insertWordInput.delegate = self
        
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
                    // START TIMER
                    
                    
                    // DISPLAY TABLE VIEW
                    self.tableView.isHidden = false
                    
                    // UNLOCK ENTRY FIELD
                    self.insertWordInput.isEnabled = true
                    self.insertWordInput.becomeFirstResponder()
                    
                    // CHANGE BUTTON TEXT
                    self.startButton.setTitle("Reset", for: .normal)
                    break
                    
                case .stopped:
                    // STOP TIMER
                    
                    
                    // CLEAR
                    self.insertWordInput.text = ""
                    self.viewModel.restartGame()
                    self.tableView.reloadData()
                    
                    // BLOCK ENTRY FIELD
                    self.insertWordInput.isEnabled = false
                    self.insertWordInput.resignFirstResponder()
                    
                    // CHANGE BUTTON TEXT
                    self.startButton.setTitle("Start", for: .normal)
                    break
                    
                case .congratz:
                    self.alert(message: "Good job! You found all the answers on time. Keep up with the great work.",
                               title: "Congratulations",
                               buttonText: "Play Again",
                               completion: {
                                self.viewModel.gameStatus.value = .retry
                    })
                    break
                    
                case .failed:
                    self.alert(message: "Sorry, time is up! You got \(self.viewModel.matchedKeywords.count) out of \(self.viewModel.keywordsModel?.answer.count ?? 50) answers.",
                               title: "Time finished",
                               buttonText: "Try Again",
                               completion: {
                                self.viewModel.gameStatus.value = .retry
                    })
                    break
                    
                case .retry:
                    // CLEAR
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
    
    @IBAction func executeTest(_ sender: Any) {
        viewModel.startResetGame()

        // TODO: TIMER
        // TODO: ALERT
        // TODO: COUNT HITS
        // TODO: HITS THROUGH TYPING
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        let keywordTyped = insertWordInput.text ?? ""
        if viewModel.matchedKeyword(keywordTyped) {
            insertWordInput.text = ""
            tableView.reloadData()
        }
    }
}

extension QuizzViewController: UITextFieldDelegate {
    
}
