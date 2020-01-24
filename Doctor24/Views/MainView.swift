//
//  MainView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/11.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit

import RxSwift
import RxCocoa
import NMapsMap
import SnapKit

final class HomeView: BaseView {
    // MARK: UI Componenet
    private let optionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        return mapView
    }()
    
    private lazy var lookAroundView: LookAroundView = {
        let view = LookAroundView(controlBy: vc)
        return view
    }()
    
    override func setupUI() {
        self.addSubViews()
        self.setLayout()
    }
    
    override func setBind() {
        
    }
}

// MARK: Public Function
extension HomeView {
    func drawPins(facilities: [Model.Todoc.Facility]) {
        facilities.forEach { [weak self] facility in
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: facility.latitude, lng: facility.longitude)
            marker.mapView = self?.mapView
        }
    }
}


// MARK: Private Function
extension HomeView {
    private func setLayout() {
        self.mapView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
//        self.lookAroundView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.left.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.right.equalToSuperview()
//        }
    }

    private func addSubViews() {
        self.addSubview(self.mapView)
//        self.addSubview(self.lookAroundView)
    }
}
