//
//  UIKit+Extension.swift
//  placeImage
//
//  Created by ZhihuaZhang on 2017/07/15.
//  Copyright © 2017年 Kapps Inc. All rights reserved.
//

import UIKit

@IBDesignable

class IBDesignableButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = .clear
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var leftPadding: CGFloat = 0.0
    @IBInspectable var rightPadding: CGFloat = 0.0
    @IBInspectable var titleLines: Int = 1
    
    override func draw(_ rect: CGRect) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = titleLines
        
        clipsToBounds = true
    }
    
}

@IBDesignable class IBDesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = (cornerRadius > 0)
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        super.draw(rect)
    }
}

extension UITextField {
    
    func checkLength(max: Int) {
        guard let text = text else {
            return
        }
        
        if text.count > max {
            self.text = String(text.prefix(max))
        }
    }
    
}

extension UILabel {
    func setTextSpace(value: CGFloat) {
        var attributedString: NSMutableAttributedString
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        
        attributedString.addAttribute(.kern,
                                      value: value,
                                      range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
    
    func updateAttributedString(string: String?) {
        guard let attributedString = attributedText else {
            return
        }
        
        let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
        newAttributedString.mutableString.setString(string ?? "")

        attributedText = newAttributedString
    }
}
