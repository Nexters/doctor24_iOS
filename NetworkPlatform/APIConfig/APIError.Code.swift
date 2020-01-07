//
//  APIError.Code.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

extension APIError {
    public enum Code: Int, Codable {
        case http = -9999
        case serviceExternalUnavailable
        case internalServerError
        case networkError
        case inconsistantModelParseFailed
        case opertaionCanceled
        case unknownError
        case malformedRequest
        case globalException
    }
}
