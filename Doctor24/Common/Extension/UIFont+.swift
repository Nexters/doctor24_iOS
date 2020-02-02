//
//  UIFont+.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/02.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

extension UIFont {
    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
    }

    class func semibold(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Semibold", size: size)!
    }

    class func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: size)!
    }

    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: size)!
    }

    class func light(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Light", size: size)!
    }

    class func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Thin", size: size)!
    }

    class func ultraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-UltraLight", size: size)!
    }
}
