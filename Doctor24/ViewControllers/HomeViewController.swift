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
    private let facilities = PublishSubject<[Model.Todoc.Facility]>()
    
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
    }
    
    func bind(reactor: HomeViewReactor) {
        self.homeView.panGestureMap
            .subscribe(onNext: { [weak self] _ in
//                print("self?.homeView.mapControlView.mapView.contentBounds: \(self?.homeView.mapControlView.mapView.contentBounds)")
            }).disposed(by: self.disposeBag)
        
        TodocInfo.shared.currentLocation
            .filter { $0.isValid() }
            .take(1)
            .map { HomeViewReactor.Action.viewDidLoad(location: $0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
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
