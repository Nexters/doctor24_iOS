//
//  UIColor+.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/02.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    class func white() -> UIColor {
        return UIColor(red: 255, green: 255, blue: 255)
    }
    
    class func grey1() -> UIColor {
        return UIColor(red: 92, green: 92, blue: 92)
    }
    
    class func grey2() -> UIColor {
        return UIColor(red: 159, green: 159, blue: 159)
    }

    class func grey3() -> UIColor {
        return UIColor(red: 207, green: 212, blue: 213)
    }
    
    class func grey4() -> UIColor {
        return UIColor(red: 239, green: 242, blue: 248)
    }
    
    class func grey5() -> UIColor {
        return UIColor(red: 245, green: 246, blue: 247)
    }
    
    class func black() -> UIColor {
        return UIColor(red: 46, green: 46, blue: 46)
    }
    
    class func selectedGrey() -> UIColor {
        return UIColor(red: 250, green: 252, blue: 255)
    }
    
    class func blue() -> UIColor {
        return UIColor(red: 89, green: 89, blue: 247)
    }
    
    class func red() -> UIColor {
        return UIColor(red: 245, green: 81, blue: 101)
    }
    
    class func darkBlue() -> UIColor {
        return UIColor(red: 72, green: 72, blue: 114)
    }
}

