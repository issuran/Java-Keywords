//
//  API.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

enum API {
    case quizz
}

extension API: ServiceProtocol {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "codechallenge.arctouch.com"
    }
    
    var path: String {
        switch self {
        case .quizz:            
            return "/quiz/java-keywords"
        }
    }
    
    var method: HttpMethod {
        return .get
    }
}
