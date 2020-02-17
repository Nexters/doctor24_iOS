//
//  UIView+.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import Toast_Swift

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
    
    enum ToastPostion {
        case top
        case middle
        case bottom
        
        public func positionY(frame: CGRect) -> CGFloat {
            switch self {
            case .top: return 50
            case .middle: return frame.size.height / 2
            case .bottom: return frame.size.height - 123
            }
        }
    }
    
    func toast(_ massage:String, duration:TimeInterval, color: UIColor? = nil, position: ToastPostion? = .bottom){
        var style = ToastStyle()
        style.messageAlignment = NSTextAlignment.center
        style.maxWidthPercentage = 0.86
        style.maxHeightPercentage = 1.0
        style.horizontalPadding = 18
        style.verticalPadding = 14
        style.cornerRadius = 3
        
        ToastManager.shared.isQueueEnabled = false
        
        //self.makeToast(massage, duration: duration, position: CGPoint(x: self.frame.size.width/2, y: (position?.positionY(frame: self.frame))!), style: style)
        self.makeToast(massage, duration: duration, point: CGPoint(x: self.frame.size.width/2, y: (position?.positionY(frame: self.frame))!), title: nil, image: nil, style: style, completion: nil)
    }
}
