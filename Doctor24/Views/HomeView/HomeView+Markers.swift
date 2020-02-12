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
        self.markerSignal.accept(nil)
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
    
    func unselectPins() {
        self.selectedMarker.forEach { marker in
            let facility = (marker.userInfo["tag"] as! Model.Todoc.Facilities).facilities.first
            marker.iconImage = self.pin(facility: facility!)
            marker.zIndex = 0
            marker.isForceShowIcon = false
        }
        self.dismissPreview()
        self.selectedMarker.removeAll()
    }
}
