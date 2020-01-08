//
//  APIConfig.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import Domain
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
    var parameters: API.Parameter? { get }
    var encoding: ParameterEncoding { get }
    
    func parse(_: Data) throws -> Response
    func makeRequest() -> Observable<Response>
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

extension APIConfig {
    internal var fullPath: String { return Self.domainConfig.domain + self.path }
    
    internal var fullHeaders: [String : String] {
        return ((self as? APIHeaderConfig)?.headers ?? [:]).reduce(into: Self.domainConfig.defaultHeader ?? [:]) { (result, element) in
            result[element.key] = element.value
        }
    }
    
    internal var fullParameters: [String : Any]? {
        return (self.parameters?.params ?? [:]).reduce(into: Self.domainConfig.parameters?.compactMapValues{ $0 } ?? [:] ) { (result, element) in
            result[element.key] = element.value
        }
    }
    
    func request() -> Observable<Response> {
        return self.makeRequest().globalException(self)
    }
}

extension APIConfig {
    var encoding: ParameterEncoding {
        if self.method == .get { return URLEncoding.default }
        return JSONEncoding.default
    }
}
