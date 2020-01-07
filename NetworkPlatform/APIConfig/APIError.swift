//
//  APIError.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

protocol ServiceErrorable: Codable {
    associatedtype Code: ServiceErrorCodeRawPresentable
    var code: Code { get }
    var message: String? { get }
    
    static func globalException() -> Bool
}

protocol ServiceErrorCodeRawPresentable: Codable {
    var rawValue: Int { get }
}

struct APIError<ServiceError: ServiceErrorable>: Error{
    let code  : Code
    let status: Int?
    let message: String?
    
    init(code: Code,
         status: Int? = nil,
         message: String? = nil) {
        self.code = code
        self.status = status
        self.message = message
    }
    
    init(data: Data,
         status: Int? = nil,
         type: ServiceError.Type) throws {
        let service = try JSONDecoder().decode(ServiceError.self, from: data)
        
        self.code = APIError.Code(rawValue: service.code.rawValue) ?? .http
        self.message = service.message
        self.status = status
    }
}
