//
//  TodocFacilitiy.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/01/13.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import Domain

extension API {
    struct Facility{
        let medicalType: Model.Todoc.MedicalType
        let latitude     : Double
        let longitude    : Double
        let operatingTime: Model.Todoc.Day?
        let category     : Model.Todoc.MedicalType.Category?
        let zoomLevel    : Int
    }
}

extension API.Facility: APIConfigWithError  {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/\(self.medicalType.rawValue)/latitudes/\(self.latitude)/longitudes/\(self.longitude)/facilities" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        var params = [String:Any]()
        params = ["radiusLevel": zoomLevel]
        
        if let time = self.operatingTime {
            params["operatingHours.startTime"] = time.startTime
            params["operatingHours.endTime"]   = time.endTime
        }
        
        if let category = self.category {
            params["category"] = category
        }
        print("jhh API hi")
        return .map(params)
    }
    
    func parse(_ input: Data) throws -> [Model.Todoc.Facilities] {
        return try input.parse()
    }
}
