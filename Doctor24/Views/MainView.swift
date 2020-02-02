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
    let panGestureMap     = PublishRelay<Void>()
    private let cameraType = BehaviorSubject<NMFMyPositionMode>(value: .direction)
    private let disposeBag = DisposeBag()
    private var markers = [NMFMarker]()
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    // MARK: UI Componenet
    let mapControlView: NMFNaverMapView = {
        let mapView = NMFNaverMapView(frame: CGRect.zero)
        mapView.mapView.mapType = .navi
        mapView.mapView.isNightModeEnabled = true
        mapView.showLocationButton = false
        mapView.showCompass = false
        mapView.showZoomControls = false
        mapView.mapView.logoAlign = .rightTop
        return mapView
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        return button
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("카메라", for: .normal)
        return button
    }()
    
    lazy var medicalSelectView: MedicalSelectView = {
        let view = MedicalSelectView(controlBy: vc)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 28.5
        return view
    }()
    
    private lazy var operatingView: OperatingHoursSetView = {
        let view = OperatingHoursSetView(controlBy: vc)
        return view
    }()
    
    private lazy var lookAroundView: LookAroundView = {
        let view = LookAroundView(controlBy: vc)
        return view
    }()
    
    deinit {
        self.removeGesture()
    }
    
    override func setupUI() {
        self.addSubViews()
        self.setLayout()
    }
    
    override func setBind() {
        self.addGesture()
        
        self.panGestureMap.subscribe(onNext:{ [weak self] in
            self?.searchButton.isEnabled = true
        }).disposed(by: self.disposeBag)
        
        self.cameraType
            .subscribe(onNext: { [weak self] type in
                self?.mapControlView.positionMode = type
            }).disposed(by: self.disposeBag)
        
        self.cameraButton.rx.tap
            .withLatestFrom(self.cameraType)
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
    func drawPins(facilities: [Model.Todoc.Facilities]) {
        self.markers.forEach { marker in
            marker.mapView = nil
        }
        self.markers.removeAll()
        
        facilities.forEach { [weak self] facility in
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: facility.latitude, lng: facility.longitude)
            marker.mapView = self?.mapControlView.mapView
            self?.markers.append(marker)
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
        
        self.medicalSelectView.snp.makeConstraints {
            $0.top.equalTo(self.safeArea.top)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(192)
            $0.height.equalTo(58)
        }
        
        self.searchButton.snp.makeConstraints {
            $0.right.equalTo(-10)
            $0.size.equalTo(50)
            $0.bottom.equalTo(self.cameraButton.snp.top).offset(-10)
        }
    }

    private func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
        self.addSubview(self.cameraButton)
        self.addSubview(self.medicalSelectView)
        self.addSubview(self.searchButton)
    }
    
    private func addGesture() {
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(triggerTouchAction))
        self.panGestureRecognizer.delegate = self
        self.mapControlView.mapView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    private func removeGesture() {
        self.mapControlView.mapView.removeGestureRecognizer(self.panGestureRecognizer)
    }
    
    @objc
    private func triggerTouchAction(){
        self.panGestureMap.accept(())
    }
}

extension HomeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
