//
//  TodocSecureFacility.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/03/03.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Alamofire

extension API {
    struct Secure {
        let latitude     : Double
        let longitude    : Double
    }
    
    struct DetailSecure {
        let secureId: String
    }
}

extension API.Secure: APIConfigWithError {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/secure/latitudes/\(self.latitude)/longitudes/\(self.longitude)/facilities" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return .map(nil)
    }
    
    func parse(_ input: Data) throws -> [Model.Todoc.Facilities] {
        return try input.parse()
    }
}

extension API.DetailSecure: APIConfigWithError {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/secure/facilities/\(self.secureId)" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return .map(nil)
    }
    
    func parse(_ input: Data) throws -> Model.Todoc.DetailFacility {
        return try input.parse()
    }
}
