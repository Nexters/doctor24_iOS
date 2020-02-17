//
//  ClusterListViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/11.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ClusterListViewController: FadeModalTransitionViewController {
    private let facilities: [Model.Todoc.PreviewFacility]
    private let disposeBag = DisposeBag()
    private lazy var clusterView = ClusterListView(controlBy: self, facilities: self.facilities)
    
    init(facilities: [Model.Todoc.PreviewFacility]) {
        self.facilities = facilities
        super.init()
        self.animateSetting.animation.present.damping = 0.7
        self.animateSetting.animation.dismiss.duration = 0
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clusterView.setupUI()
        self.clusterView.setBind()
    }
    
    override func loadView() {
        self.view = clusterView
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        self.clusterView.onWillPresentView()
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.clusterView.performCustomPresentationAnimation()
    }
    
    override func setBind() {
        self.clusterView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            }).disposed(by: self.disposeBag)
        
        self.clusterView.tapFacility.subscribe(onNext: { facility in
            ViewTransition.shared.execute(scene: .detail(facility: facility))
        }).disposed(by:self.disposeBag)
    }
}
