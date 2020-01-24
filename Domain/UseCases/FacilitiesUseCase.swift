//
//  FacilitiesUseCase.swift
//  Domain
//
//  Created by Haehyeon Jeong on 2020/01/14.
//  Copyright © 2020 JHH. All rights reserved.
//

import RxSwift

public protocol FacilitiesUseCase {
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>>
}
