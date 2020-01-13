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
    
    }
}

extension API.Facility {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/1.0/new" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? { return .map(nil) }
    
    func parse(_ input: Data) throws -> Model.MockData {
        return try input.parse()
    }
}