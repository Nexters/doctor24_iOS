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
    
    public enum DayOfWeek: String, Codable {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
}

extension Model.Todoc {
    public struct Day: Codable {
        public let dayOfWeek: Model.Todoc.DayOfWeek
        public let startTime: LocalTime
        public let endTime  : LocalTime
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


