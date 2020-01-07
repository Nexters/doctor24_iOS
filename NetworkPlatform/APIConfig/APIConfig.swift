//
//  APIConfig.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import RxSwift

struct API { }

protocol APIConfig {
    associatedtype Response
    associatedtype ServerConfig: DomainConfig
    associatedtype ServiceError: ServiceErrorable
    
    static var domainConfig: ServerConfig.Type { get }
    static var serviceError: ServiceError.Type { get }
    
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    
}

protocol DomainConfig {
    static var defaultHeader: [String : String]? { get }
    static var parameters: [String : Any?]? { get }
    static var manager: Alamofire.SessionManager { get }
    static var domain: String { get }
}

protocol APIHeaderConfig {
    var headers: [String : String]? { get }
}


