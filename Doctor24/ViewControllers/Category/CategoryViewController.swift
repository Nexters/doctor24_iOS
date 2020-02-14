//
//  CategoryViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/10.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: FadeModalTransitionViewController {
    private lazy var categoryView = CategoryView(controlBy: self)
    private let disposeBag = DisposeBag()
    override init() {
        super.init()
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryView.setupUI()
        self.categoryView.setBind()
    }
    
    override func loadView() {
        self.view = categoryView
    }
    
    override func setBind() {
        TodocInfo.shared.category.subscribe(onNext: { [weak self] category in
            self?.categoryView.refreshButton.isHidden = category == .전체 ? true : false
        }).disposed(by: self.disposeBag)
        
        self.categoryView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        Observable<Model.Todoc.MedicalType.Category>
            .merge(
                self.categoryView.refreshButton.rx.tap.map { .전체 },
                self.categoryView.전체.rx.tap.map{ .전체 },
                self.categoryView.소아과.rx.tap.map{ .소아과 },
                self.categoryView.내과.rx.tap.map{ .내과 },
                self.categoryView.이비인후과.rx.tap.map{ .이비인후과 },
                self.categoryView.피부과.rx.tap.map{ .피부과 },
                self.categoryView.정형외과.rx.tap.map{ .정형외과 },
                self.categoryView.안과.rx.tap.map{ .안과 },
                self.categoryView.치과.rx.tap.map{ .치과 },
                self.categoryView.한의원.rx.tap.map{ .한의원 },
                self.categoryView.산부인과.rx.tap.map{ .산부인과 },
                self.categoryView.비뇨기과.rx.tap.map{ .비뇨기과 },
                self.categoryView.정신의학과.rx.tap.map{ .정신의학과 },
                self.categoryView.성형외과.rx.tap.map{ .성형외과 },
                self.categoryView.가정의학과.rx.tap.map{ .가정의학과 },
                self.categoryView.외과.rx.tap.map{ .외과 },
                self.categoryView.신경외과.rx.tap.map{ .신경외과 },
                self.categoryView.마취통증과.rx.tap.map{ .마취통증과 },
                self.categoryView.신경과.rx.tap.map{ .신경과 }
            )
            .do(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .bind(to: TodocInfo.shared.category)
            .disposed(by: self.disposeBag)
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        self.categoryView.onWillPresentView()
    }
    
    override func onWillDismissView(){
        self.categoryView.onWillDismissView()
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.categoryView.performCustomPresentationAnimation()
    }
    
    override func performCustomDismissingAnimation() {
        self.categoryView.performCustomDismissingAnimation()
    }
}
