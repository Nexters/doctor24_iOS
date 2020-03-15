//
//  Scene.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import NetworkPlatform

import UIKit

enum Scene {
    case main
    case detail(facility: Model.Todoc.PreviewFacility)
    case around(facilities: [Model.Todoc.PreviewFacility], type: Model.Todoc.MedicalType)
    case category
    case cluster(facilities: [Model.Todoc.PreviewFacility])
    case secureGuide
    case corona
}

extension Scene {
    init(scene: Scene) {
        self = scene
    }
    
    var viewController: UIViewController {
        switch self {
        case .main:
            let networkService = NetworkPlatform.UseCaseProvider()
            let homeReactor = HomeViewReactor(service: networkService.makeFacilitiesUseCase(),
                                              coronaService: networkService.makeCoronaUsecase(),
                                              secureService: networkService.makeSecureUsecase())
            let vc = HomeViewController(reactor: homeReactor)
            return vc
            
        case .detail(let facility):
            let networkService = NetworkPlatform.UseCaseProvider()
            let detailReactor  = DetailViewReactor(service: networkService.makeFacilitiesUseCase())
            let vc = DetailViewController(facility: facility, reactor: detailReactor)
            
            return vc
            
        case .around(let facilities, let type):
            return AroundViewController(facilities: facilities,
                                        type: type)
            
        case .category:
            return CategoryViewController()
            
        case .cluster(let facilities):
            return ClusterListViewController(facilities: facilities)
            
        case .secureGuide:
            return SecureGuideViewController()
            
        case .corona:
            return CoronaViewController()
        }
    }
}

extension Scene: Equatable {
    static func == (lhs: Scene, rhs: Scene) -> Bool {
        return lhs.viewController.className == rhs.viewController.className
    }
}
