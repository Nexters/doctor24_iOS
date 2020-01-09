//
//  CompositionRoot.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

struct AppDependency {
    let window: UIWindow
}

enum CompositionRoot {
    
    @available(iOS 13.0, *)
    static func resolve(scene: UIWindowScene) -> AppDependency {
        //Service
        
        //root view controller
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        ViewTransition.shared.root = navigationController
        ViewTransition.shared.execute(scene: .main)
        
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return AppDependency(window: window)
    }
    
    static func resolve(window: UIWindow) -> AppDependency {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        ViewTransition.shared.root = navigationController
        ViewTransition.shared.execute(scene: .main)
        
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return AppDependency(window: window)
    }
}
