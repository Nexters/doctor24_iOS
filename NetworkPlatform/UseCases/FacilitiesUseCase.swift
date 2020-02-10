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
                    longitude: Double,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>{
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: nil,
                            category: nil,
                            zoomLevel: zoomLevel).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: operatingTime,
                            category: nil,
                            zoomLevel: zoomLevel).requestWithCatch()
    }
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category?,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.Facility(medicalType: type,
                            latitude: latitude,
                            longitude: longitude,
                            operatingTime: operatingTime,
                            category: category,
                            zoomLevel: zoomLevel).requestWithCatch()
    }
    
    func detailFacility(_ type: Model.Todoc.MedicalType,
                        facilityId: String) -> Observable<Result<Model.Todoc.DetailFacility, APIError<MockError>>> {
        return API.DetailFacility(medicalType: type, facilityID: facilityId).requestWithCatch()
    }
}
