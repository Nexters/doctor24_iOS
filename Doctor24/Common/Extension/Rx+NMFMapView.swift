//
//  Rx+NMFMapView.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import NMapsMap
import RxSwift
import RxCocoa

extension Reactive where Base: NMFMapView {
    var delegate: DelegateProxy<NMFMapView, NMFMapViewDelegate> {
        return RxNMFMapViewDelegateProxy.proxy(for: self.base)
    }
    
    var mapViewRegionIsChanging: Observable<Int> {
        return delegate.methodInvoked(#selector(NMFMapViewDelegate.mapViewRegionIsChanging(_:byReason:))).map { parameters in
            return parameters[1] as? Int ?? 0
        }
    }
}