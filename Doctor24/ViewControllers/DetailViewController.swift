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
    
    override func setupUI() {
        self.view.backgroundColor = .white
    }
    
    override func setBind() {

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
    }
}
