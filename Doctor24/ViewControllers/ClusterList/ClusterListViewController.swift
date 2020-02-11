//
//  ClusterListViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/11.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ClusterListViewController: FadeModalTransitionViewController {
    private let disposeBag = DisposeBag()
    private lazy var clusterView = ClusterListView(controlBy: self)
    
    override init() {
        super.init()
        self.animateSetting.animation.present.damping = 0.5
        self.animateSetting.animation.dismiss.damping = 0.5
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
    
    override func onWillDismissView(){
        self.clusterView.onWillDismissView()
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.clusterView.performCustomPresentationAnimation()
    }
    
    override func performCustomDismissingAnimation() {
        self.clusterView.performCustomDismissingAnimation()
    }
    
    override func setBind() {
        self.clusterView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
    }
}
