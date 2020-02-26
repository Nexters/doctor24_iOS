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
import struct CoreLocation.CLLocation.CLLocationCoordinate2D

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
        
        if let (southWest, northEast) = self.pinAreaRect(facilites: facilities) {
            let cameraUpdate = NMFCameraUpdate(fit: NMGLatLngBounds(southWest: southWest, northEast: northEast))
            cameraUpdate.animation = .linear
            self.mapControlView.mapView.moveCamera(cameraUpdate)
        }
    }
    
    func unselectPins() {
        self.selectedMarker.forEach { marker in
            let facility = (marker.userInfo["tag"] as! Model.Todoc.Facilities).facilities.first
            marker.iconImage = self.pin(facility: facility!)
            marker.zIndex = 0
            marker.isForceShowIcon = false
            marker.isHideCollidedMarkers = false
        }
        
        self.selectedMarker.removeAll()
    }
    
    private func pinAreaRect(facilites: [Model.Todoc.Facilities]) -> (NMGLatLng, NMGLatLng)? {
        var maxLat: Double = 0.0
        var minLat: Double = 200.0
        var maxLong: Double = 0.0
        var minLong: Double = 200.0
        let distanceMultiple = 0.1
        
        let pins = facilites.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        
        for pin in pins {
            if maxLat < pin.latitude {
                maxLat = pin.latitude
            }
            
            if minLat > pin.latitude {
                minLat = pin.latitude
            }
            
            if maxLong < pin.longitude {
                maxLong = pin.longitude
            }
            
            if minLong > pin.longitude {
                minLong = pin.longitude
            }
        }
        
        let northEast = NMGLatLng(lat: maxLat, lng: maxLong)
        let southWest = NMGLatLng(lat: minLat, lng: minLong)

        let gapLat = fabs(northEast.lat - southWest.lat) * distanceMultiple
        let gapLon = fabs(northEast.lng - southWest.lng) * distanceMultiple
        
        let southWestGap = NMGLatLng(lat: minLat - gapLat, lng: minLong - gapLon)
        let northEastGap = NMGLatLng(lat: maxLat + gapLat, lng: maxLong + gapLon)
        
        return (southWestGap, northEastGap)
    }
}
