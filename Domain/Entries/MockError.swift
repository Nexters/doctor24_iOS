//
//  MockError.swift
//  Domain
//
//  Created by gabriel.jeong on 08/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

public struct MockError: ServiceErrorable {
    public let code: MockError.Code
    public let message: String?
    
    public static func globalException() -> Bool {
        return false
    }
}

extension MockError {
    public enum Code: Int, ServiceErrorCodeRawPresentable {
        case unknownError
    }
}
