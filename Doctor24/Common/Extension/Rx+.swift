//
//  Rx+.swift
//  Doctor24
//
//  Created by gabriel.jeong on 18/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController{
    var viewDidload: ControlEvent<Void>{
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void>{
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension ObservableType {
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
