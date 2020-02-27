//
//  TodocDetailCorona.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/02/25.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Alamofire

extension API {
    struct DetailCorona {
        let coronaID: String
    }
}

extension API.DetailCorona: APIConfigWithError {
    static let domainConfig = TodocDomain.self
    static let serviceError = MockError.self
    
    var path: String { return "/api/v1/medicals/corona/facilities/\(self.coronaID)" }
    var method: HTTPMethod { return .get }
    var parameters: API.Parameter? {
        return .map(nil)
    }
    
    func parse(_ input: Data) throws -> Model.Todoc.DetailFacility {
        return try input.parse()
    }
}
