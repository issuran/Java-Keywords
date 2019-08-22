//
//  CustomButton.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomButton: UIButton {
    var bounceable: Bool = false
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var shouldBounce: Bool = false {
        didSet {
            bounceable = shouldBounce
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bounceable {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 6,
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        super.touchesBegan(touches, with: event)
    }
}
