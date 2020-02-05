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

final class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeViewReactor
    
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    private let facilities = PublishSubject<[Model.Todoc.Facilities]>()
    private var zoomLevel: Int {
        get {
            if self.homeView.mapControlView.mapView.zoomLevel < 14 {
                return 1
            } else if self.homeView.mapControlView.mapView.zoomLevel >= 14 {
                return 2
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
        self.homeView.panGestureMap
            .subscribe(onNext: { [weak self] _ in
//                print("jhh zoomLevel: \(self?.homeView.mapControlView.mapView.zoomLevel)")
//                print("self?.homeView.mapControlView.mapView.contentBounds: \(self?.homeView.mapControlView.mapView.contentBounds)")
            }).disposed(by: self.disposeBag)
        
        self.homeView.medicalSelectView.medicalType
            .withLatestFrom(TodocInfo.shared.currentLocation) { ($0,$1) }
            .skip(1)
            .map { [weak self] (type, location) in
                HomeViewReactor.Action.facilites(type: type, location: location, zoomLevel: self?.zoomLevel ?? 0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        TodocInfo.shared.currentLocation
            .filter { $0.isValid() }
            .take(1)
            .map { [weak self] location in
                return HomeViewReactor.Action.viewDidLoad(location: location, zoomLevel: self?.zoomLevel ?? 0)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.homeView.searchButton.rx.tap
            .withLatestFrom(self.homeView.medicalSelectView.medicalType)
            .do(onNext: { [weak self] _ in
                self?.homeView.searchButton.isEnabled = false
            }).map{ [weak self] type in
                let lat = self?.homeView.mapControlView.mapView.cameraPosition.target.lat ?? 0.0
                let lng = self?.homeView.mapControlView.mapView.cameraPosition.target.lng ?? 0.0
                let loc = CLLocationCoordinate2D(latitude: lat,
                                                 longitude: lng)
                return HomeViewReactor.Action.facilites(type: type, location: loc, zoomLevel: self?.zoomLevel ?? 0)
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.homeView.detailFacility
            .subscribe(onNext:{ facilities in
                
            }).disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{ $0.pins }
            .bind(to: self.facilities)
            .disposed(by: self.disposeBag)
        
        self.bind()
    }
    
    private func bind() {
        self.facilities
            .subscribe(onNext:{ [weak self] facilities in
                self?.homeView.drawPins(facilities: facilities)
            }).disposed(by: self.disposeBag)
    }
}
