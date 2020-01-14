//
//  TodocDomain.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/01/13.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire

struct TodocDomain: DomainConfig {
    static let domain: String = "http://27.96.130.44:8080"
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
