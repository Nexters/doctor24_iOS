//
//  NightFacilitiesUseCase.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/01/26.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Foundation
import RxSwift

final class NightFacilitiesUseCase: Domain.NightFacilitiesUseCase {
    func facilities(_ type: Model.Todoc.MedicalType,
                    xLatitude: Double,
                    xLongitude: Double,
                    zLatitude: Double,
                    zLongitude: Double) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.NightFacility(medicalType: type,
                                 xLatitude: xLatitude,
                                 xLongitude: xLongitude,
                                 zLatitude: zLatitude,
                                 zLongitude: zLongitude,
                                 operatingTime: nil,
                                 category: nil).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    xLatitude: Double,
                    xLongitude: Double,
                    zLatitude: Double,
                    zLongitude: Double,
                    operatingTime: Model.Todoc.Day) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.NightFacility(medicalType: type,
                                 xLatitude: xLatitude,
                                 xLongitude: xLongitude,
                                 zLatitude: zLatitude,
                                 zLongitude: zLongitude,
                                 operatingTime: operatingTime,
                                 category: nil).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    xLatitude: Double,
                    xLongitude: Double,
                    zLatitude: Double,
                    zLongitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.NightFacility(medicalType: type,
                                 xLatitude: xLatitude,
                                 xLongitude: xLongitude,
                                 zLatitude: zLatitude,
                                 zLongitude: zLongitude,
                                 operatingTime: operatingTime,
                                 category: category).requestWithCatch()
    }
    
    
}

