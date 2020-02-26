//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import Foundation

public final class UseCaseProvider: Domain.UseCaseProvider {
    public init() { }
    
    public func makeFacilitiesUseCase() -> Domain.FacilitiesUseCase {
        return FacilitiesUseCase()
    }
    
    public func makeNightFacilitiesUseCase() -> Domain.NightFacilitiesUseCase {
        return NightFacilitiesUseCase()
    }
    
    public func makeCoronaUsecase() -> Domain.CoronaUsecase {
        return CoronaUsecase()
    }
}

