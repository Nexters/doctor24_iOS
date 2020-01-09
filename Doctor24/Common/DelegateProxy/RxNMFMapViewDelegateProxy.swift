//
//  RxNMFMapViewDelegateProxy.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import NMapsMap
import RxSwift
import RxCocoa

class RxNMFMapViewDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewDelegate>, DelegateProxyType, NMFMapViewDelegate {
    static func registerKnownImplementations() {
        self.register{ mapView -> RxNMFMapViewDelegateProxy in
            RxNMFMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: NMFMapView) -> NMFMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: NMFMapViewDelegate?, to object: NMFMapView) {
        object.delegate = delegate
    }
}
