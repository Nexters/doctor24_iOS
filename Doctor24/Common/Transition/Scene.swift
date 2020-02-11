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
    case around(facilities: [Model.Todoc.PreviewFacility])
    case category
    case cluster
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
                                              nightService: networkService.makeNightFacilitiesUseCase())
            let vc = HomeViewController(reactor: homeReactor)

            return vc
            
        case .detail(let facility):
            let networkService = NetworkPlatform.UseCaseProvider()
            let detailReactor  = DetailViewReactor(service: networkService.makeFacilitiesUseCase())
            let vc = DetailViewController(facility: facility, reactor: detailReactor)
            
            return vc
            
        case .around(let facilities):
            let vc = AroundViewController(facilities: facilities)
            return vc
            
        case .category:
            let vc = CategoryViewController()
            return vc
            
        case .cluster:
            let vc = ClusterListViewController()
            return vc
        }
    }
}

extension Scene: Equatable {
    static func == (lhs: Scene, rhs: Scene) -> Bool {
        return lhs.viewController.className == rhs.viewController.className
    }
}
