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
    
    // MARK: UI Componenet
    private lazy var homeView = HomeView(controlBy: self)
    private let facilities = PublishSubject<[Model.Todoc.Facility]>()
    
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
        self.rx.viewDidload
            .map { HomeViewReactor.Action.viewDidLoad(latitude: 37.5153968360202, longitude: 127.10745719189502) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{ $0.pins }
            .bind(to: self.facilities)
            .disposed(by: self.disposeBag)
        
        self.facilities
            .subscribe(onNext:{ [weak self] facilities in
                self?.homeView.drawPins(facilities: facilities)
            }).disposed(by: self.disposeBag)
        
        self.homeView.regionDidChanging.subscribe(onNext: { id in
            print("jhh id: \(id)")
        }).disposed(by: self.disposeBag)
    }
}
