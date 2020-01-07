//
//  MockDomain.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire

struct MockDomain: DomainConfig {
    static let domain: String = "https://api.itbook.store"
    static let manager: SessionManager = {
        return Alamofire.SessionManager(configuration: .default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: [:]))
    }()
    
    static var defaultHeader: [String : String]? {
        return ["Accept":"application/json"]
    }
    
    static var parameters: [String : Any?]? {
        return nil
    }
}
