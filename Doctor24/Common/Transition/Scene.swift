//
//  Scene.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import NetworkPlatform

enum Scene {
    case main
}

extension Scene {
    init(scene: Scene) {
        self = scene
    }
    
    var viewController: UIViewController {
        switch self {
        case .main:
            let networkService = NetworkPlatform.UseCaseProvider()
            let homeReactor = HomeViewReactor(service: networkService.makeFacilitiesUseCase())
            let vc = HomeViewController(reactor: homeReactor)

            return vc
        }
    }
}

extension Scene: Equatable {
    static func == (lhs: Scene, rhs: Scene) -> Bool {
        return lhs.viewController.className == rhs.viewController.className
    }
}
