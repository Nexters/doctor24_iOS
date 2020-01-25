//
//  Rx+CLLocationManager.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/25.
//  Copyright © 2020 JHH. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

extension Reactive where Base: CLLocationManager {
    public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }

    // MARK: Responding to Location Events
    public var didUpdateLocations: Observable<[CLLocation]> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocationsSubject.asObservable()
    }
}
