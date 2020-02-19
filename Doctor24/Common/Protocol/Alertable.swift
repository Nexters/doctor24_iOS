//
//  Alertable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/14.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

protocol Alertable {
    func showActionSheet(sheetActions :UIAlertAction...)
}

extension Alertable {
    func showActionSheet(sheetActions :UIAlertAction...) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        sheetActions.forEach { action in
            alertController.addAction(action)
        }
        
        alertController.addAction(cancelButton)
        
        appDelegate?.searchFrontViewController().present(alertController, animated: true, completion: nil)
    }
}

protocol MapSelectable: Alertable {
    func selectMap(latitude: Double, longitude: Double, title: String)
}

extension MapSelectable {
    func selectMap(latitude: Double, longitude: Double, title: String) {
        let apple = UIAlertAction(title: "애플 맵", style: .default, handler: { _ in
            let url = "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        })
        
        let naver = UIAlertAction(title: "네이버 지도", style: .default, handler: { _ in
            let urlStr = "nmap://route/walk?dlat=\(latitude)&dlng=\(longitude)&dname=\(title)&appname=\(Bundle.main.bundleIdentifier!)"
            guard let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else { return }

            let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.open(appStoreURL)
            }
        })
        
        let kakao = UIAlertAction(title: "카카오 맵", style: .default, handler: { _ in
            let url = URL(string: "kakaomap://route?ep=\(latitude),\(longitude)&by=FOOT")!
            let appStoreURL = URL(string: "http://itunes.apple.com/app/id304608425?mt=8")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.open(appStoreURL)
            }
        })
        
        self.showActionSheet(sheetActions: apple,naver,kakao)
    }
}
