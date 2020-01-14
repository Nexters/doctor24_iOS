//
//  Todoc.swift
//  Domain
//
//  Created by Haehyeon Jeong on 2020/01/13.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

extension Model {
    public struct Todoc { }
}

extension Model.Todoc {
    public enum MedicalType: String, Codable {
        case hospital
        case pharmacy
        case animal
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
        public let dayType  : Model.Todoc.DayType
        public let startTime: String
        public let endTime  : String
    }
    
    public struct Facility: Codable {
        let name: String
        let latitude: Double
        let longitude: Double
        let medicalType: Model.Todoc.MedicalType
        let days: [Day]
        let phone: String
        let address: String
    }
    
    public struct LocalTime: Codable {
        public let hour  : Int
        public let minute: Int
        public let second: Int
        public let nano  : Int
    }
}


