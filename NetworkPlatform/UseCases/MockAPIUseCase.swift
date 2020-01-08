//
//  MockAPIUseCase.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import Foundation
import RxSwift

final class MockUseCase: Domain.MockUseCase {
    func mockAPI() -> Observable<Result<Model.MockData, APIError<MockError>>> {
        return API.Mock().requestWithCatch()
    }
}
