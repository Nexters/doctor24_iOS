//
//  APIConfig+Error.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import RxSwift

protocol APIConfigWithError: APIConfig {
    associatedtype APISepecifiedError: Error
    func catchError(_: APIError<ServiceError>) -> APISepecifiedError?
}

extension APIConfigWithError {
    func requestWithCatch() -> Observable<Result<Response, APISepecifiedError>> {
        return self.makeRequest().map(Result<Response, APISepecifiedError>.success)
            .catchError { error -> Observable<Result<Response, APISepecifiedError>> in
                guard let apiError = error as? APIError<ServiceError> else { throw error }
                guard let serviceError = self.catchError(apiError) else { throw error }
                
                return Observable.just(.failure(serviceError))
        }
    }
}
