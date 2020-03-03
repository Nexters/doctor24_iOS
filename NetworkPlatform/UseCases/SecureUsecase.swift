//
//  SecureUsecase.swift
//  NetworkPlatform
//
//  Created by Haehyeon Jeong on 2020/03/03.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import Foundation
import RxSwift

final class SecureUsecase: Domain.SecureUsecase {
    func facilities(latitude: Double, longitude: Double) -> Observable<Result<[Model.Todoc.Facilities], APIError<MockError>>> {
        return API.Secure(latitude: latitude, longitude: longitude).requestWithCatch()
    }
    
    func detailFacility(secureId: String) -> Observable<Result<Model.Todoc.DetailFacility, APIError<MockError>>> {
        return API.DetailSecure(secureId: secureId).requestWithCatch()
    }
}

