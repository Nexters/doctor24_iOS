//
//  NSObject+Custom.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

extension NSObject {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: type(of: self).className)
    }
}

extension Date {
    var convertDate: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "a h:mm"
        dateformatter.locale = Locale(identifier: "ko_KR")
        let date = dateformatter.string(from: self)
        
        return date
    }
    
    var convertParam: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"
        let date = dateformatter.string(from: self)
        
        return date
    }
}

extension String {
    var currentConvertDate: String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"
        let date = dateformatter.date(from: self)
        return date?.convertDate ?? ""
    }
    
    var convertDate: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"
        let date = dateformatter.date(from: self)
        return date?.convertDate ?? ""
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}
