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
    let medicalType       = BehaviorRelay<Model.Todoc.MedicalType>(value: .hospital)
    let search            = BehaviorRelay<Void>(value: ())
    let regionDidChanging = PublishRelay<Int>()
    let panGestureMap     = PublishRelay<Void>()
    let markerSignal      = BehaviorRelay<NMFOverlay?>(value: nil)
    let detailFacility    = PublishRelay<Model.Todoc.PreviewFacility>()
    let previewFullSignal = PublishRelay<Void>()
    
    var markers           = [NMFMarker]()
    var selectedMarker    = Set<NMFMarker>()
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
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
    
    let cameraButton = CameraButton()
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "category"), for: .normal)
        button.setImage(UIImage(named: "unCategory"), for: .highlighted)
        button.backgroundColor = .white()
        button.setShadow(radius: 30,
                         shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                         shadowOffset: CGSize(width: 0, height: 2),
                         shadowBlur: 6)
        return button
    }()
    
    let activeCategory = UIImageView(image: UIImage(named: "activeCategory"))
    
    lazy var medicalSelectView: MedicalSelectView = {
        let view = MedicalSelectView(controlBy: vc)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.setShadow(radius: 28.5,
                       shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                       shadowOffset: CGSize(width: 0, height: 2),
                       shadowBlur: 6)
        return view
    }()
    
    lazy var preview: PreviewFacilityView = {
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
    
    lazy var operatingView: OperatingHoursSetView = {
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
        btn.setShadow(radius: 30,
                      shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                      shadowOffset: CGSize(width: 0, height: 2),
                      shadowBlur: 6)
        return btn
    }()
    
    let retrySearchView = RetrySearchView()
    
    deinit {
        self.removeGesture()
    }
    
    override func setupUI() {
        if TodocInfo.shared.theme == .light {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .black
        }
        
        self.addSubViews()
        self.setLayout()
        self.layoutIfNeeded()
    }
    
    override func setBind() {
        self.addGesture()

        Observable.merge(self.operatingView.pickerConfirm.asObservable(),
                         self.operatingView.refreshButton.rx.tap.asObservable())
            .do(onNext:  { [weak self] in
                self?.dismissOperatingView()
            })
            .bind(to: self.search)
            .disposed(by: self.disposeBag)
        
        self.operatingView.closeButton.rx.tap
            .do(onNext: { _ in
                TodocEvents.TimeFilter.close.commit()
            })
            .subscribe(onNext: { [weak self] in
                self?.dismissOperatingView()
            }).disposed(by: self.disposeBag)
        
        
        Observable.merge(self.operatingView.startView.startTimeButton.rx.tap.asObservable(),
                         self.operatingView.endView.endTimeButton.rx.tap.asObservable())
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if let state = try? self.operatingView.viewState.value(), state == .close {
                    self.onOperatorBack()
                    self.onOperatingView()
                }
            }).disposed(by: self.disposeBag)

        self.retrySearchView.button.rx.tap
            .do(onNext: {
                TodocEvents.Retry.click.commit()
            })
            .bind(to: self.search)
            .disposed(by: self.disposeBag)
        
        self.panGestureMap.subscribe(onNext:{ [weak self] in
            self?.cameraButton.cameraType.onNext(.normal)
            self?.retrySearchView.hidden(false)
        }).disposed(by: self.disposeBag)
        
        self.cameraButton.cameraType
            .subscribe(onNext: { [weak self] type in
                self?.mapControlView.positionMode = type
            }).disposed(by: self.disposeBag)
        
        self.medicalSelectView.medicalType
            .bind(to: self.medicalType)
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
            .do(onNext: { facility in
                TodocEvents.Marker.detail(id: facility.id,
                                          name: facility.name,
                                          category: facility.categories?.joined(separator: ", ") ?? "",
                                          type: facility.medicalType.rawValue).commit()
            })
            .bind(to: self.detailFacility)
            .disposed(by: self.disposeBag)
        
        self.categoryButton.rx.tap.subscribe(onNext: {
            TodocEvents.MedicalCategory.click.commit()
            ViewTransition.shared.execute(scene: .category)
        }).disposed(by: self.disposeBag)
        
        self.markerSignal
            .subscribe(onNext: { [weak self] overlay in
                guard let self = self else { return }
                
                if !self.selectedMarker.isEmpty {
                    TodocEvents.Marker.dimmed.commit()
                }
                
                self.dismissPreview()
                if let selected = overlay as? NMFMarker {
                    self.cameraButton.cameraType.onNext(.normal)
                    let facilities = selected.userInfo["tag"] as! Model.Todoc.Facilities
                    if facilities.facilities.count > 1 {
                        ViewTransition.shared.execute(scene: .cluster(facilities: facilities.facilities))
                    } else if let facility = facilities.facilities.first {
                        TodocEvents.Marker.click(id: facility.id,
                                                 name: facility.name,
                                                 category: facility.categories?.joined(separator: ", ") ?? "",
                            type: facility.medicalType.rawValue).commit()
                        
                        selected.iconImage = self.detailPin(name: facility.name,
                                                            medicalType: facility.medicalType,
                                                            night: facility.nightTimeServe,
                                                            emergency: facility.emergency)
                        selected.zIndex = 1
                        selected.isHideCollidedMarkers = true
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
    
    func moveToCurrentCamera() -> Observable<Void>{
        return Observable.create{ observer in
            let dispose = TodocInfo.shared.currentLocation
                .subscribe(onNext : { [weak self] location in
                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.latitude, lng: location.longitude), zoomTo: 14)
                    cameraUpdate.animation = .linear
                    self?.mapControlView.mapView.moveCamera(cameraUpdate, completion: { _ in
                        observer.onNext(())
                        observer.onCompleted()
                    })
                })
            
            return Disposables.create{
                dispose.dispose()
            }
        }
    }
}

extension HomeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
