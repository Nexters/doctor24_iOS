//
//  ViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeViewReactor
    
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    private let viewDidLoadSignal = PublishSubject<Void>()
    
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
        self.viewDidLoadSignal.onNext(())
    }
    
    func bind(reactor: HomeViewReactor) {
        self.viewDidLoadSignal
            .debug("jhh viewDidLoadSignal")
            .map { HomeViewReactor.Action.viewDidLoad(latitude: 37.5153968360202, longitude: 127.10745719189502) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{ $0.pins }
            .subscribe(onNext: { pins in
                print("jhh pins: \(pins)")
            }).disposed(by: self.disposeBag)
    }
}
