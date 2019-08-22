//
//  RequestStatus.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

enum RequestStates<Data, Error> {
    case empty
    case load(Data)
    case loading
    case error(Error)
}
