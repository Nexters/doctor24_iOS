//
//  Todoc.swift
//  Domain
//
//  Created by Haehyeon Jeong on 2020/01/13.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

public protocol Facility {
    var id       : String { get }
    var name     : String { get }
    var latitude : Double { get }
    var longitude: Double { get }
    var medicalType: Model.Todoc.MedicalType { get }
    var phone    : String? { get }
    var address  : String { get }
    var categories: [String]? { get }
    var emergency: Bool   { get }
    var nightTimeServe: Bool { get }
}

extension Model {
    public struct Todoc { }
}

extension Model.Todoc {
    public enum MedicalType: String, Codable {
        case hospital
        case pharmacy
        case animal
        case corona
        case secure
    }
    
    public enum DayType: String, Codable {
        case MONDAY
        case TUESDAY
        case WEDNESDAY
        case THURSDAY
        case FRIDAY
        case SATURDAY
        case SUNDAY
        case HOLIDAY
    }
}

extension Model.Todoc {
    public struct Day: Codable {
        public let dayType  : Model.Todoc.DayType?
        public let startTime: String
        public let endTime  : String
        
        public init(dayType: Model.Todoc.DayType? = nil,
             starTime: String,
             endTime: String) {
            self.dayType   = dayType
            self.startTime = starTime
            self.endTime   = endTime
        }
    }
    
    public struct DetailFacility: Codable, Facility {
        public let id       : String
        public let name     : String
        public let latitude : Double
        public let longitude: Double
        public let medicalType: Model.Todoc.MedicalType
        public let days     : [Day]
        public let phone    : String?
        public let address  : String
        public let categories: [String]?
        public let emergency: Bool
        public let nightTimeServe: Bool
        public let today: Day
    }
    
    public struct PreviewFacility: Codable, Facility {
        public let id       : String
        public let name     : String
        public let latitude : Double
        public let longitude: Double
        public let medicalType: Model.Todoc.MedicalType
        public let day       : Day
        public let phone     : String?
        public let address   : String
        public let categories: [String]?
        public let emergency: Bool
        public let nightTimeServe: Bool
    }
    
    public struct LocalTime: Codable {
        public let hour  : Int
        public let minute: Int
        public let second: Int
        public let nano  : Int
    }
    
    public struct Facilities: Codable {
        public let latitude  : Double
        public let longitude : Double
        public let facilities: [PreviewFacility]
        public let total     : Int
    }
}

extension Model.Todoc.DayType {
    public func convert() -> String {
        switch self {
        case .MONDAY:
            return "월"
        case .TUESDAY:
            return "화"
        case .WEDNESDAY:
            return "수"
        case .THURSDAY:
            return "목"
        case .FRIDAY:
            return "금"
        case .SATURDAY:
            return "토요일"
        case .SUNDAY:
            return "일요일"
        case .HOLIDAY:
            return "공휴일"
        }
    }
}

extension Model.Todoc.Day: Hashable {
    public static func == (lhs: Model.Todoc.Day, rhs: Model.Todoc.Day) -> Bool {
        return lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
    }
}

extension Model.Todoc.DetailFacility {
    public func convertDaysArray() -> [[Model.Todoc.Day]] {
        var set = [[Model.Todoc.Day]]()
        var daysTemp = self.days.filter { $0.dayType ?? .MONDAY != .SATURDAY && $0.dayType ?? .MONDAY != .SUNDAY && $0.dayType ?? .MONDAY != .HOLIDAY }
        
        for tempDay in daysTemp {
            guard daysTemp.contains(tempDay) else { continue }
            var differArr = [Model.Todoc.Day]()
            for differ in daysTemp {
                if tempDay == differ {
                    differArr.append(differ)
                    daysTemp.remove(at: daysTemp.firstIndex(of: differ) ?? 0)
                }
            }
            
            set.append(differArr)
        }
        
        _ = self.days.filter {
            $0.dayType ?? .MONDAY == .SATURDAY || $0.dayType ?? .MONDAY == .SUNDAY || $0.dayType ?? .MONDAY == .HOLIDAY
        }.forEach { day in
            set.append([day])
        }
        
        return set
    }
}

extension Model.Todoc.MedicalType {
    public enum Category: String, Codable {
        case 전체
        case 소아과
        case 내과
        case 이비인후과
        case 피부과
        case 정형외과
        case 안과
        case 치과
        case 한의원
        case 산부인과
        case 비뇨기과
        case 정신의학과
        case 성형외과
        case 가정의학과
        case 외과
        case 신경외과
        case 마취통증과
        case 신경과
    }
}
