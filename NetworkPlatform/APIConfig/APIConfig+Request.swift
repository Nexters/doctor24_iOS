//
//  APIConfig+Request.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Alamofire
import RxSwift

extension APIConfig {
    internal func makeRequest() -> Observable<Response> {
        return Observable<Response>.create { (observer: AnyObserver<Response>) -> Disposable in
            print("\n\n")
            print("********** REQUEST **********")
            print("-fullPath: \(self.fullPath)")
            print("-parameter: \(self.parameters?.params ?? [:])")
            print("*********************************")
            print("\n")
            
            let request = Self.domainConfig.manager.request(self.fullPath,
                                                            method: self.method,
                                                            parameters: self.fullParameters,
                                                            encoding: self.encoding,
                                                            headers: self.fullHeaders)
            request.validate().responseData(completionHandler: self.responseHandler(observer))
            
            return Disposables.create { request.cancel() }
        }
    }
}

extension APIConfig {
    private func responseHandler(_ observer: AnyObserver<Response>) -> ((DataResponse<Data>) -> Void) {
        return { (response: DataResponse<Data>) -> Void in
            switch response.result {
            case .success(let data):
                do {
                    if let description = String(data:data, encoding: .utf8) {
                        print("\n\n")
                        print("********** RESPONSE : \(Self.Response.self) **********")
                        print(description)
                        print("*********************************")
                        print("\n")
                    }
                    
                    let response = try self.parse(data)
                    observer.onNext(response)
                    observer.onCompleted()
                } catch let error {
                    observer.onError(APIError<ServiceError>.init(code: .inconsistantModelParseFailed,
                                                                 message: error.localizedDescription))
                }
                
            case .failure(let error):
                if let errorDate = response.data {
                    print(String(data: errorDate, encoding: .utf8) ?? "")
                }
                
                observer.onError(self.failHandler(error: error, response: response))
            }
            
        }
    }
    
    private func failHandler(error: Error, response: DataResponse<Data>) -> APIError<ServiceError> {
        guard error.isCanceled == false else {
            return APIError(code: .opertaionCanceled)
        }
        
        guard let afError = error as? AFError else {
            print("\n\n")
            print("**********  OS ERROR FAIL CODE ********** ")
            print("-error: \(error)")
            print("*********************************")
            print("\n")
            return APIError(code: .networkError)
        }
        
        guard case let .responseValidationFailed(reason: .unacceptableStatusCode(code: status)) = afError else {
            return APIError.init(code: .malformedRequest)
        }
        
        switch status {
        case 503:
            return APIError(code: .serviceExternalUnavailable, status: status, message: afError.localizedDescription)
            
        case (500..<600):
            print("\n\n")
            print("**********  HTTP ERROR FAIL **********")
            print("-HTTP status: \(status)")
            print("*********************************")
            print("\n")
            
            return APIError.init(code: .internalServerError, status: status, message: afError.localizedDescription)
        default:
            guard let data = response.data, let error = try? APIError(data: data, status: status, type: Self.serviceError.self) else {
                return APIError(code: .http, status: nil, message: afError.localizedDescription)
            }
            
            return error
        }
    }
}

extension Observable {
    internal func globalException<T: APIConfig>(_ target: T) -> Observable {
        return self.do(onNext:{ data in
            print("\n\n")
            print("********** API SUCCESS **********")
            print("-success: [\(target.method)] \(target.path)")
            print("-header: \(target.fullHeaders)")
            print("-parameter: \(target.fullParameters ?? [:])")
            print("-data: \(data)")
            print("*********************************")
            print("\n")
        }, onError: { error in
            print("\n\n")
            print("********** API FAILED **********")
            print("-success: [\(target.method)] \(target.path)")
            print("-header: \(target.fullHeaders)")
            print("-parameter: \(target.fullParameters ?? [:])")
            print("-errror: \(error)")
            print("*********************************")
            print("\n")
        }).catchError{ error -> Observable<Element> in
            guard let apiError = error as? APIError<T.ServiceError> else { throw error }
            if T.ServiceError.globalException() == true {
                throw APIError<T.ServiceError>.init(code: .globalException, status: apiError.status, message: apiError.message)
            } else {
                throw apiError
            }
        }
    }
}

extension Error {
    fileprivate var isCanceled: Bool {
        return (self as NSError).domain == NSURLErrorDomain && (self as NSError).code == NSURLErrorCancelled
    }
}
