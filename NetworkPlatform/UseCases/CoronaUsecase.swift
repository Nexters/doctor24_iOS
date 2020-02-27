//
//  CoronaUsecase.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/02/25.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Foundation
import RxSwift

final class CoronaUsecase: Domain.CoronaUsecase {
    func facilities(latitude: Double, longitude: Double) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.Corona(latitude: latitude, longitude: longitude).requestWithCatch()
    }
    
    func detailFacility(coronaID: String) -> Observable<Result<Model.Todoc.DetailFacility, APIError<MockError>>> {
        return API.DetailCorona(coronaID: coronaID).requestWithCatch()
    }
    
    
}
