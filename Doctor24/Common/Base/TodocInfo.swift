//
//  TodocInfo.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/25.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import Foundation
import MapKit
import RxSwift
import RxCocoa

final class TodocInfo {
    static let shared = TodocInfo()
    
    let startTimeFilter = BehaviorSubject<Date?>(value: nil)
    let endTimeFilter   = BehaviorSubject<Date?>(value: nil)
    let currentLocation = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    let category        = BehaviorSubject<Model.Todoc.MedicalType.Category>(value: .전체)
    
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private init() {
        self.locationManagerInit()
        self.locationManager.rx
            .didUpdateLocations
            .map{ $0[0].coordinate }
            .bind(to: currentLocation)
            .disposed(by: self.disposeBag)
    }
    
    func locationManagerInit() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
}
