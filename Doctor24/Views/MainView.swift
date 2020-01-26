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
    private let cameraType = BehaviorSubject<NMFMyPositionMode>(value: .direction)
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
        return mapView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("카메라", for: .normal)
        return button
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
        self.cameraType
            .subscribe(onNext: { [weak self] type in
                self?.mapControlView.positionMode = type
            }).disposed(by: self.disposeBag)
        
        self.cameraButton.rx.tap.withLatestFrom(self.cameraType)
            .map { type -> NMFMyPositionMode in
                switch type {
                case .normal:
                    return .direction
                case .direction:
                    return .compass
                case .compass:
                    return .normal
                default:
                    return .normal
                }}
            .bind(to: self.cameraType)
            .disposed(by: self.disposeBag)
        
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
        
        self.cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(self.operatingView.snp.top).offset(-10)
            $0.right.equalTo(-10)
            $0.size.equalTo(50)
        }
    }

    private func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
        self.addSubview(self.cameraButton)
    }
}
