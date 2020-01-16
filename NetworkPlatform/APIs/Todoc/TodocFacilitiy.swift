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
        let latitude : Double
        let longitude: Double
    }
}

extension API.Facility: APIConfigWithError  {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/\(self.medicalType.rawValue)/facilities" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? { return .map(["latitude":self.latitude,
                                                  "longitude":self.longitude]) }
    
    func parse(_ input: Data) throws -> [Model.Todoc.Facility] {
        return try input.parse()
    }
}
