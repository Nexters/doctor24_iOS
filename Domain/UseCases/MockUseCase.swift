//
//  MockUseCase.swift
//  Domain
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import RxSwift

public protocol MockUseCase {
    func mockAPI() -> Observable<Result<Model.MockData, Error>>
}
