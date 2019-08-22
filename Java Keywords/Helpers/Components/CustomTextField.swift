//
//  CustomTextField.swift
//  Java Keywords
//
//  Created by Tiago Oliveira on 21/08/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil
                ? self.placeholder!
                : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor!])
        }
    }
}
