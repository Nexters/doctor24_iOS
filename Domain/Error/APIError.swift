//
//  APIError.swift
//  Domain
//
//  Created by gabriel.jeong on 08/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

public protocol ServiceErrorable: Codable {
    associatedtype Code: ServiceErrorCodeRawPresentable
    var code: Code { get }
    var message: String? { get }
    
    static func globalException() -> Bool
}

public protocol ServiceErrorCodeRawPresentable: Codable {
    var rawValue: Int { get }
}

public struct APIError<ServiceError: ServiceErrorable>: Error{
    public let code  : Code
    public let status: Int?
    public let message: String?
    
    public init(code: Code,
         status: Int? = nil,
         message: String? = nil) {
        self.code = code
        self.status = status
        self.message = message
    }
    
    public init(data: Data,
         status: Int? = nil,
         type: ServiceError.Type) throws {
        let service = try JSONDecoder().decode(ServiceError.self, from: data)
        
        self.code = APIError.Code(rawValue: service.code.rawValue) ?? .http
        self.message = service.message
        self.status = status
    }
}
