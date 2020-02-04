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
    var phone    : String { get }
    var address  : String { get }
    var emergency: Bool   { get }
    var nightTimeServe: Bool { get }
}

extension Model {
    public struct Todoc { }
}

extension Model.Todoc {
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
        public let dayType  : Model.Todoc.DayType?
        public let startTime: String
        public let endTime  : String
    }
    
    public struct DetailFacility: Codable, Facility {
        public let id       : String
        public let name     : String
        public let latitude : Double
        public let longitude: Double
        public let medicalType: Model.Todoc.MedicalType
        public let days     : [Day]
        public let phone    : String
        public let address  : String
        public let emergency: Bool
        public let nightTimeServe: Bool
    }
    
    public struct PreviewFacility: Codable, Facility {
        public let id       : String
        public let name     : String
        public let latitude : Double
        public let longitude: Double
        public let medicalType: Model.Todoc.MedicalType
        public let day      : Day
        public let phone    : String
        public let address  : String
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

extension Model.Todoc.MedicalType {
    public enum Category: String {
        case 내과
        case 외과
    }
}
