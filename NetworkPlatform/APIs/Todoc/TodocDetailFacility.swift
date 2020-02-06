//
//  TodocDetailFacility.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/02/06.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import Domain

extension API {
    struct DetailFacility {
        let medicalType: Model.Todoc.MedicalType
        let facilityID : String
    }
}

extension API.DetailFacility: APIConfigWithError  {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/\(self.medicalType.rawValue)/facilities/\(self.facilityID)" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return .map(nil)
    }
    
    func parse(_ input: Data) throws -> Model.Todoc.DetailFacility {
        return try input.parse()
    }
}
