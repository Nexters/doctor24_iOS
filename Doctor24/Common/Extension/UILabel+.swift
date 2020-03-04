//
//  UILabel+.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/04.
//  Copyright © 2020 JHH. All rights reserved.
//
import UIKit

extension UILabel {
    func setLinespace(spacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                         value: style,
                                         range: NSMakeRange(0, attributeString.length))
            
            self.attributedText = attributeString
        }
    }
}


