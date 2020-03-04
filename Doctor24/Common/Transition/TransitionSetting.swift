//
//  TransitionSetting.swift
//  Doctor24
//
//  Created by gabriel.jeong on 14/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

struct TransitionSetting {
    struct AnimationStyle{
        public var scale: CGSize? = nil
        public var present = PresentAnimationStyle()
        public var dismiss = DismissAnimationStyle()
    }
    
    struct PresentAnimationStyle {
        public var damping = CGFloat(0.7)
        public var delay = TimeInterval(0.0)
        public var duration = TimeInterval(0.4)
        public var springVelocity = CGFloat(0.0)
        public var options = UIView.AnimationOptions.curveLinear
    }
    
    struct DismissAnimationStyle {
        public var damping = CGFloat(0.7)
        public var delay = TimeInterval(0.3)
        public var duration = TimeInterval(0.4)
        public var springVelocity = CGFloat(0.0)
        public var options = UIView.AnimationOptions.curveLinear
        public var offset = CGFloat(0)
    }
    
    public var animation      = AnimationStyle()
    public static func defaultSettings() -> TransitionSetting {
        return TransitionSetting()
    }
}
