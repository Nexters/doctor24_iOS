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
    func compareTimeOnly(to: Date) -> ComparisonResult {
        let calendar = Calendar.current
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!
        
        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        if seconds == 0 {
            return .orderedSame
        } else if seconds > 0 {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }
    
    var ampm: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "a"
        dateformatter.locale = Locale(identifier: "ko_KR")
        let date = dateformatter.string(from: self)
        
        return date
    }
    
    var convertDate: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "a h:mm"
        dateformatter.locale = Locale(identifier: "ko_KR")
        let date = dateformatter.string(from: self)
        
        return date
    }
    
    var convertTotal: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
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
    
    var convertTotal: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"
        let date = dateformatter.date(from: self)
        return date?.convertTotal ?? ""
    }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}
