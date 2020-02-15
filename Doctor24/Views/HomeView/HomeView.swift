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

final class HomeView: BaseView, PinDrawable {
    // MARK: Property
    let search            = BehaviorRelay<Void>(value: ())
    let regionDidChanging = PublishRelay<Int>()
    let panGestureMap     = PublishRelay<Void>()
    let markerSignal      = BehaviorRelay<NMFOverlay?>(value: nil)
    let detailFacility    = PublishRelay<Model.Todoc.PreviewFacility>()
    let previewFullSignal = PublishRelay<Void>()
    
    var markers           = [NMFMarker]()
    var selectedMarker    = Set<NMFMarker>()
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
        mapView.mapView.logoMargin = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 24)
        return mapView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white()
        button.layer.cornerRadius = 30
        return button
    }()
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "category"), for: .normal)
        button.setImage(UIImage(named: "unCategory"), for: .highlighted)
        button.layer.cornerRadius = 30
        button.backgroundColor = .white()
        return button
    }()
    
    private let activeCategory = UIImageView(image: UIImage(named: "activeCategory"))
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(onDetailView(_:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    lazy var operatingBackGround: UIView = {
        let view = UIView()
        view.backgroundColor = .black()
        view.alpha = 0
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissOperatingView(_:)))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private lazy var operatingView: OperatingHoursSetView = {
        let view = OperatingHoursSetView(controlBy: vc)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(operatingDragView(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(onOperatingView(_:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    let aroundListButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.setImage(UIImage(named: "selectedList"), for: .highlighted)
        btn.backgroundColor = .white()
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let retrySearchView: RetrySearchView = {
        let view = RetrySearchView()
        view.backgroundColor = .white()
        view.layer.cornerRadius = 22
        view.hidden(true)
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
        
        Observable.merge(self.retrySearchView.button.rx.tap.asObservable(),
                         self.operatingView.pickerConfirm.asObservable(),
                         self.operatingView.refreshButton.rx.tap.asObservable())
            .do(onNext:  { [weak self] in
                self?.dismissOperatingView()
            })
            .bind(to: self.search)
            .disposed(by: self.disposeBag)
        
        self.panGestureMap.subscribe(onNext:{ [weak self] in
            self?.cameraButton.setImage(UIImage(named: "cameraOff"), for: .normal)
            self?.retrySearchView.hidden(false)
        }).disposed(by: self.disposeBag)
        
        self.cameraType
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .normal:
                    self?.cameraButton.setImage(UIImage(named: "cameraOff"), for: .normal)
                case .direction:
                    self?.cameraButton.setImage(UIImage(named: "camera2"), for: .normal)
                case .compass:
                    self?.cameraButton.setImage(UIImage(named: "camera3"), for: .normal)
                default:
                    break
                }
                
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
        
        self.previewFullSignal
            .do(onNext: { [weak self] in
                self?.dismissPreview()
            }).withLatestFrom(self.markerSignal).map{
                ($0?.userInfo["tag"] as? Model.Todoc.Facilities)?.facilities.first
            }.unwrap()
            .bind(to: self.detailFacility)
            .disposed(by: self.disposeBag)
        
        self.categoryButton.rx.tap.subscribe(onNext: {
            ViewTransition.shared.execute(scene: .category)
        }).disposed(by: self.disposeBag)
        
        self.markerSignal
            .subscribe(onNext: { [weak self] overlay in
                guard let self = self else { return }
                
                self.dismissPreview()
                if let selected = overlay as? NMFMarker {
                    self.cameraType.onNext(.normal)
                    let facilities = selected.userInfo["tag"] as! Model.Todoc.Facilities
                    if facilities.facilities.count > 1 {
                        ViewTransition.shared.execute(scene: .cluster(facilities: facilities.facilities))
                    } else if let facility = facilities.facilities.first {
                        selected.iconImage = self.detailPin(name: facility.name, medicalType: facility.medicalType)
                        selected.zIndex = 1
                        selected.isForceShowIcon = true
                        self.selectedMarker.insert(selected)
                        self.onPreview(with: facility)
                    }
                }
            }).disposed(by: self.disposeBag)
        
        TodocInfo.shared.category
            .subscribe(onNext: { [weak self] category in
                self?.activeCategory.isHidden = category == .전체 ? true : false
            }).disposed(by: self.disposeBag)
    }
}

// MARK: Private Function
extension HomeView {
    private func setLayout() {
        self.mapControlView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.operatingView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(self.frame.height - 132 - self.bottomSafeAreaInset)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(396 + bottomSafeAreaInset)
        }
        
        self.cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(self.operatingView.snp.top).offset(-24)
            $0.right.equalTo(-24)
            $0.size.equalTo(58)
        }
        
        self.categoryButton.snp.makeConstraints {
            $0.bottom.equalTo(self.operatingView.snp.top).offset(-24)
            $0.left.equalTo(24)
            $0.size.equalTo(58)
        }
        
        self.medicalSelectView.snp.makeConstraints {
            $0.top.equalTo(self.safeArea.top)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(192)
            $0.height.equalTo(58)
        }
        
        self.retrySearchView.snp.makeConstraints {
            $0.top.equalTo(self.medicalSelectView.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(110)
            $0.height.equalTo(44)
        }
        
        self.preview.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        self.aroundListButton.snp.makeConstraints {
            $0.size.equalTo(58)
            $0.centerY.equalTo(self.medicalSelectView)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.activeCategory.snp.makeConstraints {
            $0.top.right.equalTo(self.categoryButton)
            $0.size.equalTo(20)
        }
    }

    private func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
        self.addSubview(self.cameraButton)
        self.addSubview(self.categoryButton)
        self.addSubview(self.activeCategory)
        self.addSubview(self.medicalSelectView)
        self.addSubview(self.retrySearchView)
        self.addSubview(self.preview)
        self.addSubview(self.aroundListButton)
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
    
    @objc
    private func onOperatingView(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.onOperatingView()
    }
    
    @objc
    private func dismissOperatingView(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.dismissOperatingView()
    }
    
    @objc
    private func onDetailView(_ gestureRecognizer: UIPanGestureRecognizer){
        self.previewFullSignal.accept(())
    }
    
    private func onPreview(with facility: Model.Todoc.PreviewFacility) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: facility.latitude, lng: facility.longitude))
        self.mapControlView.mapView.moveCamera(cameraUpdate)
        self.preview.setData(facility: facility)
        self.layoutIfNeeded()
        var height: CGFloat = 0
        
        
        if facility.medicalType == .hospital {
            height = 293 + self.preview.titleStack.frame.height + self.bottomSafeAreaInset //317
        } else {
            height = 223 + self.preview.titleStack.frame.height + self.bottomSafeAreaInset //295
        }
        
        self.preview.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        })
    }
    
    func dismissPreview() {
        if !self.selectedMarker.isEmpty {
            self.unselectPins()
        }
        self.preview.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        })
    }
    
    func onOperatorBack() {
        self.addSubview(self.operatingBackGround)
        self.operatingBackGround.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        self.bringSubviewToFront(self.operatingView)
    }
    
    func removeOperatorBack() {
        self.operatingBackGround.snp.removeConstraints()
        self.operatingBackGround.removeFromSuperview()
    }
    
    func onOperatingView() {
        self.operatingBackGround.alpha = 0.6
        self.operatingView.viewState.onNext(.open)
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height - (396 + bottomSafeAreaInset))
        }
        
        self.animateOpertaingView(show: true)
    }
    
    func dismissOperatingView() {
        self.removeOperatorBack()
        self.operatingView.viewState.onNext(.close)
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height -  (132 + bottomSafeAreaInset))
        }
        
        self.animateOpertaingView(show: false)
        self.bringSubviewToFront(self.preview)
    }
    
    func animateOpertaingView(show: Bool) {
        
        var alpha : CGFloat = 0.0
        let maxFontSize:CGFloat = 1
        let minFontSize:CGFloat = 0.87
        var size:CGFloat = 0.0
        
        let start        = operatingView.startView.startTimeLabel
        let end          = operatingView.endView.endTimeLabel
        let spaincg      = operatingView.spacingLabel
        let pickerView   = operatingView.pickerView
        let background   = operatingView.operatingBackgroundView
        
        if show {
            alpha  = 1.0
            size = minFontSize
        } else {
            alpha  = 0.0
            size = maxFontSize
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        let transform = CGAffineTransform(scaleX: size, y: size)
                        start.transform = transform
                        end.transform   = transform
                        spaincg.transform = transform
                        
                        pickerView.alpha = alpha
                        background.alpha = alpha
                        
                        self.layoutIfNeeded()
        })
        
    }
}

extension HomeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
