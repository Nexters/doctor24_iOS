//
//  DetailViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/06.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa


class DetailViewController: BaseViewController, View {
    typealias Reactor = DetailViewReactor
    
    private let facility: Model.Todoc.PreviewFacility
    private let detailFacility = PublishSubject<Model.Todoc.DetailFacility>()
    private lazy var detailView = DetailView(controlBy: self)
    var disposeBag: DisposeBag = DisposeBag()
    
    init(facility: Model.Todoc.PreviewFacility,
         reactor: DetailViewReactor) {
        self.facility = facility
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailView.setupUI()
        self.detailView.setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupUI() {
        self.view.backgroundColor = .white
    }
    
    override func setBind() {
        self.detailView.topBar.closeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                TodocEvents.Detail.close.commit()
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by:self.disposeBag)
    }
    
    func bind(reactor: DetailViewReactor) {
        self.rx.viewDidload
            .map { [weak self] _ -> DetailViewReactor.Action in
                return DetailViewReactor
                    .Action
                    .viewDidLoad(type: self?.facility.medicalType ?? .hospital,
                                 id: self?.facility.id ?? "")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{ $0.data }
            .unwrap()
            .bind(to: self.detailFacility)
            .disposed(by: self.disposeBag)
        
        self.detailFacility.subscribe(onNext: { [weak self] facility in
            self?.detailView.facility = facility
        }).disposed(by: self.disposeBag)
    }
}
