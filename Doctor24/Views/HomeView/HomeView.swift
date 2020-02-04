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
    let markerSignal      = BehaviorRelay<NMFOverlay?>(value: nil)
    var markers           = [NMFMarker]()
    private var selectedMarker = Set<NMFMarker>()
    private let cameraType = BehaviorSubject<NMFMyPositionMode>(value: .direction)
    private let disposeBag = DisposeBag()
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
    
    private lazy var preview: PreviewFacilityView = {
        let view = PreviewFacilityView(controlBy: vc)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(previewDragView(_:)))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var operatingView: OperatingHoursSetView = {
        let view = OperatingHoursSetView(controlBy: vc)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(operatingDragView(_:)))
        view.addGestureRecognizer(gesture)
        
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
        
        self.mapControlView.mapView.rx
            .didTapMapView
            .map { nil }
            .bind(to: self.markerSignal)
            .disposed(by: self.disposeBag)
        
        self.mapControlView.mapView
            .rx.mapViewRegionDidChanging
            .bind(to: self.regionDidChanging)
            .disposed(by: self.disposeBag)
        
        self.markerSignal
            .subscribe(onNext: { [weak self] overlay in
                guard let self = self else { return }
                
                if let selected = overlay as? NMFMarker {
                    let facilities = selected.userInfo["tag"] as! Model.Todoc.Facilities
                    if facilities.facilities.count > 1 {
                        
                    } else if let facility = facilities.facilities.first {
                        selected.iconImage = self.detailPin(name: facility.name, medicalType: facility.medicalType)
                        self.selectedMarker.insert(selected)
                        self.onPreview(with: facility)
                    }
                } else {
                    if !self.selectedMarker.isEmpty {
                        self.selectedMarker.forEach { marker in
                            let facility = (marker.userInfo["tag"] as! Model.Todoc.Facilities).facilities.first
                            marker.iconImage = self.pin(facility: facility!)
                        }
                        self.dismissPreview()
                        self.selectedMarker.removeAll()
                    }
                }
            }).disposed(by: self.disposeBag)
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
            $0.top.equalToSuperview().offset(self.frame.height - 132 - self.bottomSafeAreaInset)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(396 + bottomSafeAreaInset)
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
        
        self.preview.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
    }

    private func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
        self.addSubview(self.cameraButton)
        self.addSubview(self.medicalSelectView)
        self.addSubview(self.searchButton)
        self.addSubview(self.preview)
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
    
    private func onPreview(with facility: Model.Todoc.PreviewFacility) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: facility.latitude, lng: facility.longitude))
        self.mapControlView.mapView.moveCamera(cameraUpdate)
        self.preview.setData(facility: facility)
        
        UIView.animate(withDuration: 0.3) {
            self.preview.snp.updateConstraints {
                $0.height.equalTo(279 + self.bottomSafeAreaInset)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func dismissPreview() {
        UIView.animate(withDuration: 0.3) {
            self.preview.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }
    }
}

extension HomeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
