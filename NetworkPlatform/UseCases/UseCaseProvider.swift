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

    public func makeMockAPIUseCase() -> Domain.MockUseCase {
        return MockUseCase()
    }
}

