//
//  AroundViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/09.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AroundViewController: BaseViewController {
    // MARK: UI Component
    private lazy var aroundView = AroundView(controlBy: self,
                                             facilities: facilities,
                                             type: self.type)
    private let facilities: [Model.Todoc.PreviewFacility]
    private let type: Model.Todoc.MedicalType
    private let disposeBag = DisposeBag()
    
    init(facilities: [Model.Todoc.PreviewFacility],
         type: Model.Todoc.MedicalType) {
        self.facilities = facilities
        self.type = type
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TodocEvents.Around.click(type: self.type.rawValue).commit()
        self.aroundView.setupUI()
        self.aroundView.setBind()
    }
    
    override func loadView() {
        self.view = self.aroundView
    }
    
    override func setupUI() {
        
    }
    
    override func setBind() {
        self.aroundView.topBar.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        self.aroundView.tapFacility.subscribe(onNext: { facility in
            if let facility = facility {
                ViewTransition.shared.execute(scene: .detail(facility: facility))
            }
        }).disposed(by:self.disposeBag)
    }
}
