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
    // MARK: Property
    let regionDidChanging = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let optionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let mapControlView: NMFNaverMapView = {
        let mapView = NMFNaverMapView(frame: CGRect.zero)
        mapView.mapView.mapType = .navi
        mapView.mapView.isNightModeEnabled = true
        mapView.showLocationButton = true
        mapView.showZoomControls = false
        mapView.positionMode = .direction
        return mapView
    }()
    
    private lazy var operatingView: OperatingHoursSetView = {
        let view = OperatingHoursSetView(controlBy: vc)
        return view
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
        self.mapControlView.mapView
            .rx.mapViewRegionDidChanging
            .bind(to: self.regionDidChanging)
            .disposed(by: self.disposeBag)
    }
}

// MARK: Public Function
extension HomeView {
    func drawPins(facilities: [Model.Todoc.Facility]) {
        facilities.forEach { [weak self] facility in
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: facility.latitude, lng: facility.longitude)
            marker.mapView = self?.mapControlView.mapView
        }
    }
}

// MARK: Private Function
extension HomeView {
    private func setLayout() {
        self.mapControlView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.operatingView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(102 + bottomSafeAreaInset)
        }
    }

    private func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
    }
}
