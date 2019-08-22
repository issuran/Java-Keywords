//
//  HUD.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 20/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class HUD {
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let label = UILabel()
    
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: HUD {
        struct Static {
            static let instance: HUD = HUD()
        }
        return Static.instance
    }
    
    public func showLoading(_ view: UIView) {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(hex: "333333", alpha: 0.4)
    
        loadingView.frame = CGRect(x: 0, y: 0, width: 180, height: 120)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(hex: "000000", alpha: 0.8)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: (loadingView.frame.size.height / 2) - 15)
    
        let textString = "Loading..."
        label.text = textString
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.sizeToFit()
        label.center = CGPoint(x: activityIndicator.center.x, y: activityIndicator.center.y + 40)
    
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(label)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    public func hideLoading() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
