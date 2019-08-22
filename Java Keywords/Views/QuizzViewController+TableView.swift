//
//  QuizzViewController+TableView.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 22/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

extension QuizzViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = viewModel.matchedKeywords[indexPath.row]
        return cell
    }
}
