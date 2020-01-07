//
//  MockError.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

struct MockError: ServiceErrorable {
    let code: MockError.Code
    let message: String?
    
    static func globalException() -> Bool {
        return false
    }
}

extension MockError {
    enum Code: Int, ServiceErrorCodeRawPresentable {
        case unknownError
    }
}
