//
//  MockAPI.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import Domain

extension API {
    struct Mock: APIConfigWithError {
        static let domainConfig = MockDomain.self
        static let serviceError = MockError.self
        
        var path: String { return "/1.0/new" }
        var method: HTTPMethod { return .get }
        var parameters: API.Parameter? { return .map(nil) }
        
        func parse(_ input: Data) throws -> Model.MockData {
            return try input.parse()
        }
        
        func catchError(_ error: APIError<MockError>) -> FailStatus? {
            switch error.code {
            case .unknownError:
                return nil
            default:
                return nil
            }
        }
        
        enum FailStatus: Error {
            case updateError(String?)
        }
    }
}
