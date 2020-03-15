//
//  CoronaStackView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/03.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit
import RxSwift
import RxCocoa

final class CoronaTag: UIView {
    // MARK: Properties
    let coronaType = BehaviorRelay<CoronaSearchType>(value: .none)
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let coronaButton = CoronaButton(title: "코로나진료소")
    private let secureButton = CoronaButton(title: "국민안심병원")
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupUI()
        self.setBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CoronaTag {
    private func setupUI() {
        self.addSubview(self.coronaButton)
        self.addSubview(self.secureButton)
        
        self.coronaButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalTo(self.secureButton.snp.left).offset(-16)
            $0.width.equalTo(101)
        }
        
        self.secureButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(101)
        }
    }
    
    private func setBind() {
        let secureState = self.secureButton.buttonState
        self.coronaButton.buttonState
            .flatMap { coronaState in
                secureState.map { (coronaState, $0) }.take(1)
            }
            .subscribe(onNext:  { [weak self] (coronaState, secureState) in
                guard let self = self else { return }
                switch (coronaState,secureState) {
                case (.focused,.normal):
                    self.coronaType.accept(.corona)
                case (.normal, .focused):
                    self.coronaType.accept(.secure)
                case (.focused, .focused):
                    self.coronaType.accept(.corona)
                    self.secureButton.buttonState.accept(.normal)
                case (.normal, .normal):
                    self.coronaType.accept(.none)
                }
            }).disposed(by: self.disposeBag)
            
        
        let coronaState = self.coronaButton.buttonState
        self.secureButton.buttonState
            .flatMap { secureState in
                coronaState.map { (secureState, $0) }.take(1)
            }
            .subscribe(onNext:  { [weak self] (secureState, coronaState) in
                guard let self = self else { return }
                switch (secureState, coronaState) {
                case (.focused,.normal):
                    self.coronaType.accept(.secure)
                case (.normal, .focused):
                    self.coronaType.accept(.corona)
                case (.focused, .focused):
                    self.coronaType.accept(.secure)
                    self.coronaButton.buttonState.accept(.normal)
                case (.normal, .normal):
                    self.coronaType.accept(.none)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func onNormalButtons() {
        self.secureButton.buttonState.accept(.normal)
        self.coronaButton.buttonState.accept(.normal)
    }
}

extension CoronaTag {
    enum CoronaSearchType: String {
        case none
        case corona = "코로나진료소"
        case secure = "국민안심병원"
        
        func medicalType() -> Model.Todoc.MedicalType? {
            switch self {
            case .corona:
                return .corona
            case .secure:
                return .secure
            default :
                return nil
            }
        }
    }
}
