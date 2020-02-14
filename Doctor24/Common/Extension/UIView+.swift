//
//  UIView+.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
    }
    
    var haveSafeArea: Bool {
        if #available(iOS 11.0, *) {
            if bottomSafeAreaInset > CGFloat(0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    var topSafeAreaInset: CGFloat {
        let window = UIApplication.shared.keyWindow
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            topPadding = window?.safeAreaInsets.top ?? 0
        }
        
        return topPadding
    }
    
    var bottomSafeAreaInset: CGFloat {
        let window = UIApplication.shared.keyWindow
        var bottomPadding: CGFloat = 0
        
        bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        
        return bottomPadding
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func setShadow(radius: CGFloat,
                   shadowColor: UIColor,
                   shadowOffset: CGSize,
                   shadowBlur: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = shadowBlur / 2
        self.layer.masksToBounds = false
    }
}
