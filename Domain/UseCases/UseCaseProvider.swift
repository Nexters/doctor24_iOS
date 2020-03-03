//
//  UseCaseProvider.swift
//  Domain
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    // 병원, 약국 검색
    func makeFacilitiesUseCase() -> FacilitiesUseCase
    
    // 코로나 진료소 검색
    func makeCoronaUsecase() -> CoronaUsecase
    
    // 안심병원 검색
    func makeSecureUsecase() -> SecureUsecase
}
