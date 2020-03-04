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
    
    let startTimeFilter = BehaviorSubject<Date?>(value: Date())
    let endTimeFilter   = BehaviorSubject<Date?>(value: Date().addingTimeInterval(TimeInterval(60.0*60.0)))
    let currentLocation = BehaviorSubject<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    let category        = BehaviorSubject<Model.Todoc.MedicalType.Category>(value: .전체)
    var theme           = Theme.light
    
    var isShowSecureGuide: Bool {
        let pref = UserDefaults.standard
        if pref.bool(forKey: "showGuideSecure") {
            return pref.bool(forKey: "showGuideSecure")
        }else{
            return false
        }
    }
    
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private init() {
        self.locationManagerInit()
        self.locationManager.rx
            .didUpdateLocations
            .map{ $0[0].coordinate }
            .bind(to: currentLocation)
            .disposed(by: self.disposeBag)
        self.initTheme()
        
    }
    
    func locationManagerInit() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func showSecureGuide() {
        let pref = UserDefaults.standard
        pref.set(true, forKey: "showGuideSecure")
        pref.synchronize()
    }
    
    private func initTheme() {
        let standardLight = "08:00:00"
        let standardNight = "18:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let light = dateFormatter.date(from: standardLight)!
        let night = dateFormatter.date(from: standardNight)!

        switch (Date().compareTimeOnly(to: light), Date().compareTimeOnly(to: night)) {
        case (.orderedSame, _):
            theme = .light
        case (_, .orderedSame):
            theme = .night
        case (.orderedDescending, .orderedAscending):
            theme = .light
        case (.orderedAscending, .orderedAscending):
            theme = .night
        case (.orderedDescending, .orderedDescending):
            theme = .night
        default:
            break
        }
    }
}

enum Theme {
    case light
    case night
}
