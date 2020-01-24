//
//  FacilitiesUseCase.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/01/14.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Foundation
import RxSwift

final class FacilitiesUseCase: Domain.FacilitiesUseCase {
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>>{
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: nil,
                            category: nil).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>> {
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: operatingTime,
                            category: nil).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category) -> Observable<Result<[Model.Todoc.Facility], APIError<MockError>>> {
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: operatingTime,
                            category: category).requestWithCatch()
    }
}
