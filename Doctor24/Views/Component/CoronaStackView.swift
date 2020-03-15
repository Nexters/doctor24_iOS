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
    let coronaType = BehaviorRelay<CoronaSearchType>(value: .mask)
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let maskButton   = CoronaButton(title: "공적마스크")
    private let coronaButton = CoronaButton(title: "코로나진료소")
    private let secureButton = CoronaButton(title: "국민안심병원")
    private let containerStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .horizontal
        stkView.spacing = 18
        return stkView
    }()
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
        self.addSubview(self.containerStack)
        self.containerStack.addArrangedSubview(self.maskButton)
        self.containerStack.addArrangedSubview(self.coronaButton)
        self.containerStack.addArrangedSubview(self.secureButton)
        
        self.containerStack.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        self.maskButton.snp.makeConstraints {
            $0.width.equalTo(89)
        }
        
        self.coronaButton.snp.makeConstraints {
            $0.width.equalTo(101)
        }
        
        self.secureButton.snp.makeConstraints {
            $0.width.equalTo(101)
        }
    }
    
    private func setBind() {
        self.coronaType.subscribe(onNext: { [weak self] state in
            switch state{
            case .corona:
                self?.coronaButton.buttonState.accept(.focused)
                self?.maskButton.buttonState.accept(.normal)
                self?.secureButton.buttonState.accept(.normal)
            case .mask:
                self?.maskButton.buttonState.accept(.focused)
                self?.coronaButton.buttonState.accept(.normal)
                self?.secureButton.buttonState.accept(.normal)
            case .secure:
                self?.secureButton.buttonState.accept(.focused)
                self?.coronaButton.buttonState.accept(.normal)
                self?.maskButton.buttonState.accept(.normal)
            }
        }).disposed(by: self.disposeBag)
        
        self.maskButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.coronaType.accept(.mask)
        }).disposed(by: self.disposeBag)
        
        self.coronaButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.coronaType.accept(.corona)
        }).disposed(by: self.disposeBag)
        
        self.secureButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.coronaType.accept(.secure)
        }).disposed(by: self.disposeBag)
    }
    
    func onNormalButtons() {
        self.secureButton.buttonState.accept(.normal)
        self.coronaButton.buttonState.accept(.normal)
    }
}

extension CoronaTag {
    enum CoronaSearchType: String {
        case mask   = "공적마스크"
        case corona = "코로나진료소"
        case secure = "국민안심병원"
        
        func medicalType() -> Model.Todoc.MedicalType? {
            switch self {
            case .mask:
                return .mask
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
