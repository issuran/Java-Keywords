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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    convenience init(viewModel: QuizzViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    self.questionLabel.text = self.viewModel.keywordsModel.question
                    
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
        // TODO: TIMER
    }
}
