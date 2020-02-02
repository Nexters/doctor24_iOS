//
//  TodocNightFacility.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/01/26.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import Domain

extension API {
    struct NightFacility {
        let medicalType: Model.Todoc.MedicalType
        let xLatitude     : Double
        let xLongitude    : Double
        let zLatitude     : Double
        let zLongitude    : Double
        let operatingTime: Model.Todoc.Day?
        let category     : Model.Todoc.MedicalType.Category?
    }
}

extension API.NightFacility: APIConfigWithError  {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String {
        return "/api/v1/medicals/\(self.medicalType.rawValue)/xlatitudes/\(self.xLatitude)/xlongitudes/\(self.xLongitude)/zlatitudes/\(self.zLatitude)/zlongitudes/\(self.zLongitude)/facilities"
    }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        var params = [String:Any]()
        
        if let time = self.operatingTime {
            params = ["operatingHours.startTime": time.startTime,
                      "operatingHours.endTime"  : time.endTime]
        }
        
        if let category = self.category {
            params = ["category": category]
        }
        
        return .map(params)
    }
    
    func parse(_ input: Data) throws -> [Model.Todoc.Facilities] {
        return try input.parse()
    }
}
