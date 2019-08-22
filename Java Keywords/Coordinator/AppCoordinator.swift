//
//  AppCoordinator.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 20/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    
    required init(_ window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let quizzViewModel = QuizzViewModel()
        let quizzViewController = QuizzViewController(viewModel: quizzViewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(quizzViewController, animated: true)
    }
}
