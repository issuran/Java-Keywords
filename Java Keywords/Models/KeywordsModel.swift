//
//  KeywordsModel.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

struct KeywordsModel: Codable {
    let question: String
    let answer: [String]
    
    init() {
        self.question = String()
        self.answer = [String]()
    }
}
