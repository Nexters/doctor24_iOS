//
//  AppDelegate.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import NMapsMap

let appDelegate = UIApplication.shared.delegate as? AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var dependency: AppDependency!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13, *) { print("set in SceneDelegate") }
        else {
            NMFAuthManager.shared().clientId = "kmnj0rb8vt"
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            self.window?.rootViewController = SplashViewController()
            self.window?.makeKeyAndVisible()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.dependency = self.dependency ?? CompositionRoot.resolve(window: window)
                self.window     = self.dependency.window
            }
        }

        return true
    }

    private func searchFrontViewController(_ viewController : UIViewController)->UIViewController{
        var vc = viewController
        if let presentVC = viewController.presentedViewController {
            vc = self.searchFrontViewController(presentVC)
        }
        return vc
    }
    
    
    func searchFrontViewController()->UIViewController{
        var vc = UIApplication.shared.windows.first?.rootViewController
        vc = self.searchFrontViewController(vc!)
        return vc!
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

