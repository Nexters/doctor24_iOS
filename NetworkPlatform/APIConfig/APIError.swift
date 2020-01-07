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
