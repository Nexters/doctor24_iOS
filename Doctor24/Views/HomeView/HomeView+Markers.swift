//
//  HomeView+Markers.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/04.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import Domain
import NMapsMap

// MARK: Draw Pins
extension HomeView {
    func drawPins(facilities: [Model.Todoc.Facilities]) {
        self.markers.forEach { marker in
            marker.mapView = nil
        }
        self.markers.removeAll()
        
        facilities.forEach { [weak self] facility in
            guard let first = facility.facilities.first, let self = self else { return }
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: facility.latitude, lng: facility.longitude)
            marker.mapView = self.mapControlView.mapView
            marker.userInfo = ["tag": facility]
            marker.touchHandler = { [weak self] overlay in
                self?.markerSignal.accept(overlay)
                return true
            }
            
            if facility.facilities.count > 1 {
                marker.iconImage = self.clusterPin(count: facility.facilities.count)
            } else {
                marker.iconImage = self.pin(facility: first)
            }
            
            self.markers.append(marker)
        }
    }
    
    func pin(facility: Model.Todoc.Facility) -> NMFOverlayImage {
        switch (facility.emergency, facility.nightTimeServe, facility.medicalType == .pharmacy) {
        case (_, _, true):
            //약국
            return NMFOverlayImage(name: "drugStore")
        case (_, true, false):
            //야간
            return NMFOverlayImage(name: "nightHospital")
        case (true, false, false):
            //응급
            return NMFOverlayImage(name: "emergency")
        default:
            //기본
            return NMFOverlayImage(name: "hospital")
        }
    }
    
    func clusterPin(count: Int) -> NMFOverlayImage {
        let container   = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        let defaultMark = UIImageView(image: UIImage(named: "hospital"))
        let countImg    = UIImageView(image: UIImage(named: "number"))
        let countLabel  = UILabel()
        
        countLabel.textAlignment = .center
        countLabel.text = "\(count)"
        countLabel.textColor = .black()
        countLabel.font = UIFont.bold(size: 10)
        
        container.addSubview(defaultMark)
        container.addSubview(countImg)
        container.addSubview(countLabel)
        
        defaultMark.frame = CGRect(x: 0, y: 32 - 24, width: 24, height: 24)
        countImg.frame    = CGRect(x: 32 - 20, y: 0, width: 20, height: 20)
        countLabel.frame  = CGRect(x: 0, y: 0, width: 12, height: 12)
        countLabel.center = countImg.center
        
        return NMFOverlayImage(image: container.asImage())
    }
}
