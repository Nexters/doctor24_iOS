//
//  FacilityTitleable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/07.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit
import CoreLocation.CLLocation

protocol FacilityTitleable {
    func distance(lat: Double, long: Double) -> String
    func typeImg(with facility: Facility) -> UIImage?
    func category(with facility: Facility) -> String?
}

extension FacilityTitleable {
    func distance(lat: Double, long: Double) -> String {
        if let current = try? TodocInfo.shared.currentLocation.value() {
            let currentLoc = CLLocation(latitude: current.latitude, longitude: current.longitude)
            let distance = currentLoc.distance(from: CLLocation(latitude: lat, longitude: long))
            
            let numberFormatter = NumberFormatter()
            numberFormatter.roundingMode = .floor
            numberFormatter.minimumSignificantDigits = 2
            numberFormatter.maximumSignificantDigits = 2

            let newNum = numberFormatter.string(from: NSNumber(value: distance / 1000))
            
            return "\(newNum ?? "0")km"
        }
        
        return "km"
    }
    
    func typeImg(with facility: Facility) -> UIImage? {
        guard facility.medicalType == .hospital else { return nil }
        switch (facility.nightTimeServe, facility.emergency) {
        case (true, _):
            return UIImage(named: "nightType")
            
        case (false, true):
            return UIImage(named: "emergencyType")
        default:
            return nil
        }
    }
    
    func category(with facility: Facility) -> String? {
        guard let categories = facility.categories, categories.count > 0 else { return nil }
        
        let convert = categories.map { type in Model.Todoc.MedicalType.Category(rawValue: type) }.compactMap { $0 }
//        let except  = categories.
        
        print("jhh convert: \(convert)")
        
        let categoriesNoWhiteSpc = categories.map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        
        return categoriesNoWhiteSpc.joined(separator: ", ")
    }
}
