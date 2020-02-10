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
                    longitude: Double,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    latitude: Double,
                    longitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category?,
                    zoomLevel: Int) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
    
    func detailFacility(_ type: Model.Todoc.MedicalType,
                        facilityId: String) -> Observable<Result<Model.Todoc.DetailFacility, APIError<MockError>>>
}

public protocol NightFacilitiesUseCase {
    func facilities(_ type    : Model.Todoc.MedicalType,
                    xLatitude : Double,
                    xLongitude: Double,
                    zLatitude : Double,
                    zLongitude: Double) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    xLatitude : Double,
                    xLongitude: Double,
                    zLatitude : Double,
                    zLongitude: Double,
                    operatingTime: Model.Todoc.Day) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
    
    func facilities(_ type: Model.Todoc.MedicalType,
                    xLatitude : Double,
                    xLongitude: Double,
                    zLatitude : Double,
                    zLongitude: Double,
                    operatingTime: Model.Todoc.Day,
                    category: Model.Todoc.MedicalType.Category) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>>
}
