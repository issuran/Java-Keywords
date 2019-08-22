//
//  Coordinator.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 20/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

protocol Coordinator {
    var window: UIWindow { get set }
    var navigationController: UINavigationController { get set }
    
    init(_ window: UIWindow)
    
    func start()
}
