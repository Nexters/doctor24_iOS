//
//  CoronaView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit

import RxSwift
import RxCocoa
import NMapsMap
import SnapKit

final class CoronaView: BaseView {
    let panGestureMap     = PublishRelay<Void>()
    var panGestureRecognizer: UIPanGestureRecognizer!
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        button.setShadow(radius: 22,
                         shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                         shadowOffset: CGSize(width: 0, height: 2),
                         shadowBlur: 6)
        return button
    }()
    
    let mapControlView: NMFNaverMapView = {
        let mapView = NMFNaverMapView(frame: CGRect.zero)
        if TodocInfo.shared.theme == .night {
            mapView.mapView.mapType = .navi
            mapView.mapView.isNightModeEnabled = true
        }
        
        mapView.showLocationButton = false
        mapView.showCompass = false
        mapView.showZoomControls = false
        mapView.mapView.logoAlign = .rightTop
        mapView.mapView.logoMargin = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 24)
        mapView.mapView.maxZoomLevel = 17
        mapView.mapView.minZoomLevel = 10
        return mapView
    }()
    
    let retrySearchView = RetrySearchView()
    let coronaTag = CoronaTag()
    let maskInfo = CoronaMaskInfoView()
    let cameraButton = CameraButton()
    
    deinit {
        self.removeGesture()
    }
    
    override func setupUI() {
        self.addSubViews()
        self.setLayout()
        self.addGesture()
        self.layoutIfNeeded()
    }
    
    override func setBind() {
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.vc.dismiss(animated: true, completion: nil)
        }).disposed(by:self.disposeBag)
        
        self.cameraButton.cameraType.subscribe(onNext: { [weak self] type in
            self?.mapControlView.positionMode = type
        }).disposed(by: self.disposeBag)
        
        self.panGestureMap.subscribe(onNext:{ [weak self] in
            self?.cameraButton.cameraType.onNext(.normal)
            self?.retrySearchView.hidden(false)
        }).disposed(by: self.disposeBag)
    }
}
