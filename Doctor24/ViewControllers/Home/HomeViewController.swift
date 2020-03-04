//
//  ViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import CoreLocation
import ReactorKit
import RxSwift
import RxCocoa
import Toast_Swift
import NMapsMap

final class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeViewReactor
    
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    private let facilities = PublishSubject<[Model.Todoc.Facilities]>()
    private var zoomLevel: Int {
        get {
            if self.homeView.mapControlView.mapView.zoomLevel < 14 {
                return 2
            } else if self.homeView.mapControlView.mapView.zoomLevel >= 14 {
                return 1
            }
            return 1
        }
    }
    
    // MARK: UI Componenet
    private lazy var homeView = HomeView(controlBy: self)
    
    init(reactor: HomeViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView(){
        self.view = self.homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeView.setupUI()
        self.homeView.setBind()
    }
    
    func bind(reactor: HomeViewReactor) {
        let selectMedical = self.homeView.medicalSelectView.medicalType
            .withLatestFrom(self.homeView.coronaTag.coronaType) { ($0,$1) }.filter { $1 == .none }.map { $0.0 }
        
        Observable.combineLatest(selectMedical,
                                 Observable.combineLatest(TodocInfo.shared.startTimeFilter.unwrap(),
                                                          TodocInfo.shared.endTimeFilter.unwrap()),
                                 TodocInfo.shared.category,
                                 self.homeView.search.mapToVoid()) {($0, $1.0, $1.1, $2, $3) }
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.homeView.retrySearchView.hidden(true)
            })
            .map { [weak self] (type, startTime, endTime, category, _) -> HomeViewReactor.Action in
            let lat = self?.homeView.mapControlView.mapView.cameraPosition.target.lat ?? 0.0
            let lng = self?.homeView.mapControlView.mapView.cameraPosition.target.lng ?? 0.0
            let loc = CLLocationCoordinate2D(latitude: lat,
                                             longitude: lng)
            let day = Model.Todoc.Day(starTime: startTime.convertParam, endTime: endTime.convertParam)
            
            return HomeViewReactor.Action.facilites(type: type,
                                                    location: loc,
                                                    zoomLevel: self?.zoomLevel ?? 0,
                                                    day: day,
                                                    category: type == .pharmacy ? nil : category)
        }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
        
        self.homeView.coronaSearch
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] state in
                self?.homeView.retrySearchView.hidden(true)
                if state == .secure && TodocInfo.shared.isShowSecureGuide == false {
                    ViewTransition.shared.execute(scene: .secureGuide)
                }
            })
            .map { [weak self] state in
                let lat = self?.homeView.mapControlView.mapView.cameraPosition.target.lat ?? 0.0
                let lng = self?.homeView.mapControlView.mapView.cameraPosition.target.lng ?? 0.0
                let loc = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                if state == .corona {
                    return HomeViewReactor.Action.corona(location: loc)
                } else {
                    return HomeViewReactor.Action.secure(location: loc)
                }
                
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.merge(TodocInfo.shared.currentLocation.filter { $0.isValid() }.take(1),
                         self.homeView.coronaTag.coronaType.filter { $0 == .none }.withLatestFrom(TodocInfo.shared.currentLocation)
        )
            .withLatestFrom(Observable.combineLatest(TodocInfo.shared.startTimeFilter.unwrap(),
                                                     TodocInfo.shared.endTimeFilter.unwrap())) { ($0,$1.0,$1.1) }
            .skip(1)
            .do(onNext:{ [weak self] (location, _, _) in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.latitude, lng: location.longitude), zoomTo: 14)
                cameraUpdate.animation = .linear
                self?.homeView.mapControlView.mapView.moveCamera(cameraUpdate)
            })
            .map { [weak self] location, startTime, endTime in
                let day = Model.Todoc.Day(starTime: startTime.convertParam, endTime: endTime.convertParam)
                return HomeViewReactor.Action.viewDidLoad(location: location,
                                                          zoomLevel: self?.zoomLevel ?? 0,
                                                          day: day)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{ $0.pins }
            .bind(to: self.facilities)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map { $0.errorMessage }
            .filter { $0 != "" }
            .subscribe(onNext: { [weak self] message in
                self?.view.toast(message, duration: 3)
            }).disposed(by: self.disposeBag)
        
        self.bind()
    }
    
    private func bind() {
        self.homeView.medicalSelectView.medicalType.withLatestFrom(TodocInfo.shared.category) { ($0,$1) }
            .skip(1)
            .subscribe(onNext: { type, category in
                self.homeView.categoryButton.isHidden = type == .hospital ? false : true
                self.homeView.coronaButtonHide(type != .hospital)
                if type == .pharmacy {
                    self.homeView.activeCategory.isHidden = true
                } else if type == .hospital && category != .전체 {
                    self.homeView.activeCategory.isHidden = false
                }
            }).disposed(by: self.disposeBag)
        
        self.facilities
            .subscribe(onNext:{ [weak self] facilities in
                self?.homeView.drawPins(facilities: facilities)
            }).disposed(by: self.disposeBag)
        
        self.facilities.filter { $0.count == 0 }
            .withLatestFrom(Observable.combineLatest(self.homeView.medicalSelectView.medicalType,
                                                     self.homeView.coronaTag.coronaType))
            .subscribe(onNext : { [weak self] medicalType, coronaType in
                if coronaType == .none {
                    self?.view.toast("현재 운영중인 \(medicalType == .hospital ? "병원":"약국")이 없습니다.", duration: 3)
                } else {
                    self?.view.toast("해당되는 병원이 없습니다.", duration: 3)
                }
            }).disposed(by: self.disposeBag)
        
        self.homeView.detailFacility
            .subscribe(onNext:{ facility in
                ViewTransition.shared.execute(scene: .detail(facility: facility))
            }).disposed(by: self.disposeBag)
        
        self.homeView.aroundListButton.rx.tap
            .withLatestFrom(self.facilities).map { facilities in
                guard let current = try? TodocInfo.shared.currentLocation.value() else { return facilities.flatMap { $0.facilities } }
                let currentLoc = CLLocation(latitude: current.latitude, longitude: current.longitude)
                
                return facilities
                    .flatMap { $0.facilities }
                    .sorted { (facility1, facility2) -> Bool in
                    let distance1 = currentLoc.distance(from: CLLocation(latitude: facility1.latitude, longitude: facility1.longitude))
                    let distance2 = currentLoc.distance(from: CLLocation(latitude: facility2.latitude, longitude: facility2.longitude))
                    
                    return distance1 < distance2
                }
            }
            .subscribe(onNext: { data in
                ViewTransition.shared.execute(scene: .around(facilities: data))
            }).disposed(by: self.disposeBag)
    }
}
