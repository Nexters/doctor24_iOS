//
//  CategoryView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/10.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit

import RxSwift
import RxCocoa

final class CategoryView: BaseView {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    private let contentView: UIView! = {
        let view = UIView()
        view.backgroundColor = .white()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "진료 과목"
        label.font = .bold(size: 14)
        label.textColor = .grey1()
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.titleLabel?.font = .medium(size: 14)
        button.setTitleColor(.blue(), for: .normal)
        return button
    }()
    
    // MARK: Category StackView
    private let stackview: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = -1
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: Category first line
    private let firstStack: UIStackView = {
        let stk = UIStackView()
        stk.spacing = -1
        stk.axis = .horizontal
        return stk
    }()
    
    lazy var 전체: UIButton = self.buttonFactory(named: "medicalEnable")
    lazy var 소아과: UIButton = self.buttonFactory(named: "pedEnable")
    lazy var 내과: UIButton = self.buttonFactory(named: "medEnable")
    lazy var 이비인후과: UIButton = self.buttonFactory(named: "entEnable")
    lazy var 피부과: UIButton = self.buttonFactory(named: "derEnable")
    
    // MARK: Category second line
    private let secondStackView: UIStackView = {
        let stk = UIStackView()
        stk.spacing = -1
        stk.axis = .horizontal
        return stk
    }()
    
    lazy var 정형외과: UIButton = self.buttonFactory(named: "osEnable")
    lazy var 안과: UIButton = self.buttonFactory(named: "ophEnable")
    lazy var 치과: UIButton = self.buttonFactory(named: "dentEnable")
    lazy var 한의원: UIButton = self.buttonFactory(named: "orientalEnable")
    lazy var 산부인과: UIButton = self.buttonFactory(named: "obgyEnable")
    
    // MARK: Category third line
    private let thirdStackView: UIStackView = {
        let stk = UIStackView()
        stk.spacing = -1
        stk.axis = .horizontal
        return stk
    }()
    
    lazy var 비뇨기과: UIButton = self.buttonFactory(named: "uroEnable")
    lazy var 정신의학과: UIButton = self.buttonFactory(named: "npEnable")
    lazy var 성형외과: UIButton = self.buttonFactory(named: "psEnable")
    lazy var 가정의학과: UIButton = self.buttonFactory(named: "comparisonfamilyEnable")
    lazy var 외과: UIButton = self.buttonFactory(named: "gsEnable")
    
    // MARK: Category fourth line
    private let fourthStackView: UIStackView = {
        let stk = UIStackView()
        stk.spacing = -1
        stk.axis = .horizontal
        return stk
    }()
    
    lazy var 신경외과: UIButton = self.buttonFactory(named: "nsEnable")
    lazy var 마취통증과: UIButton = self.buttonFactory(named: "anesthesiologyEnable")
    lazy var 신경과: UIButton = self.buttonFactory(named: "nrEnable")
    
    override func setupUI() {
        self.backgroundColor = .clear
        self.addSubViews()
        self.setLayout()
    }
    
    override func setBind() {
        TodocInfo.shared.category
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .전체:
                    self.전체.selected(named: "active")
                    self.firstStack.bringSubviewToFront(self.전체)
                    self.stackview.bringSubviewToFront(self.firstStack)
                case .소아과:
                    self.소아과.selected(named: "pedActive")
                    self.firstStack.bringSubviewToFront(self.소아과)
                    self.stackview.bringSubviewToFront(self.firstStack)
                case .내과:
                    self.내과.selected(named: "medActive")
                    self.firstStack.bringSubviewToFront(self.내과)
                    self.stackview.bringSubviewToFront(self.firstStack)
                case .이비인후과:
                    self.이비인후과.selected(named: "entActive")
                    self.firstStack.bringSubviewToFront(self.이비인후과)
                    self.stackview.bringSubviewToFront(self.firstStack)
                case .피부과:
                    self.피부과.selected(named: "derActive")
                    self.firstStack.bringSubviewToFront(self.피부과)
                    self.stackview.bringSubviewToFront(self.firstStack)
                case .정형외과:
                    self.정형외과.selected(named: "osActive")
                    self.secondStackView.bringSubviewToFront(self.정형외과)
                    self.stackview.bringSubviewToFront(self.secondStackView)
                case .안과:
                    self.안과.selected(named: "ophActive")
                    self.secondStackView.bringSubviewToFront(self.안과)
                    self.stackview.bringSubviewToFront(self.secondStackView)
                case .치과:
                    self.치과.selected(named: "dentActive")
                    self.secondStackView.bringSubviewToFront(self.치과)
                    self.stackview.bringSubviewToFront(self.secondStackView)
                case .한의원:
                    self.한의원.selected(named: "orientalActive")
                    self.secondStackView.bringSubviewToFront(self.한의원)
                    self.stackview.bringSubviewToFront(self.secondStackView)
                case .산부인과:
                    self.산부인과.selected(named: "obgyActive")
                    self.secondStackView.bringSubviewToFront(self.산부인과)
                    self.stackview.bringSubviewToFront(self.secondStackView)
                case .비뇨기과:
                    self.비뇨기과.selected(named: "uroActive")
                    self.thirdStackView.bringSubviewToFront(self.비뇨기과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .정신의학과:
                    self.정신의학과.selected(named: "npActive")
                    self.thirdStackView.bringSubviewToFront(self.정신의학과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .성형외과:
                    self.성형외과.selected(named: "psActive")
                    self.thirdStackView.bringSubviewToFront(self.성형외과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .가정의학과:
                    self.가정의학과.selected(named: "comparisonfamilyActive")
                    self.thirdStackView.bringSubviewToFront(self.가정의학과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .외과:
                    self.외과.selected(named: "gsActive")
                    self.thirdStackView.bringSubviewToFront(self.외과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .신경외과:
                    self.신경외과.selected(named: "nsActive")
                    self.thirdStackView.bringSubviewToFront(self.신경외과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .마취통증과:
                    self.마취통증과.selected(named: "anesthesiologyActive")
                    self.thirdStackView.bringSubviewToFront(self.마취통증과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                case .신경과:
                    self.신경과.selected(named: "nrActive")
                    self.thirdStackView.bringSubviewToFront(self.신경과)
                    self.stackview.bringSubviewToFront(self.thirdStackView)
                }
            }).disposed(by:self.disposeBag)
    }
}

// MARK: Animate View
extension CategoryView {
    func onWillPresentView(){
        self.backgroundView.alpha = 0.0
        self.contentView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
    
    func onWillDismissView(){
        self.backgroundView.alpha = 0.4
        self.contentView.snp.updateConstraints {
            $0.height.equalTo(self.bottomSafeAreaInset + 352)
        }
    }
    
    func performCustomPresentationAnimation() {
        self.backgroundView.alpha = 0.4
        self.contentView.snp.updateConstraints {
            $0.height.equalTo(self.bottomSafeAreaInset + 352)
        }
    }
    
    func performCustomDismissingAnimation() {
        self.backgroundView.alpha = 0.0
        self.contentView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
}

// MARK: Private function
extension CategoryView {
    private func addSubViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.refreshButton)
        self.contentView.addSubview(self.stackview)
        
        self.stackview.addArrangedSubview(self.firstStack)
        self.firstStack.addArrangedSubview(self.전체)
        self.firstStack.addArrangedSubview(self.소아과)
        self.firstStack.addArrangedSubview(self.내과)
        self.firstStack.addArrangedSubview(self.이비인후과)
        self.firstStack.addArrangedSubview(self.피부과)
        
        self.stackview.addArrangedSubview(self.secondStackView)
        self.secondStackView.addArrangedSubview(self.정형외과)
        self.secondStackView.addArrangedSubview(self.안과)
        self.secondStackView.addArrangedSubview(self.치과)
        self.secondStackView.addArrangedSubview(self.한의원)
        self.secondStackView.addArrangedSubview(self.산부인과)
        
        self.stackview.addArrangedSubview(self.thirdStackView)
        self.thirdStackView.addArrangedSubview(self.비뇨기과)
        self.thirdStackView.addArrangedSubview(self.정신의학과)
        self.thirdStackView.addArrangedSubview(self.성형외과)
        self.thirdStackView.addArrangedSubview(self.가정의학과)
        self.thirdStackView.addArrangedSubview(self.외과)
        
        self.stackview.addArrangedSubview(self.fourthStackView)
        self.fourthStackView.addArrangedSubview(self.신경외과)
        self.fourthStackView.addArrangedSubview(self.마취통증과)
        self.fourthStackView.addArrangedSubview(self.신경과)
        self.fourthStackView.addArrangedSubview(self.emptyViewFactory())
        self.fourthStackView.addArrangedSubview(self.emptyViewFactory())
        
    }
    
    private func setLayout() {
        self.backgroundView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel)
            $0.size.equalTo(26)
            $0.left.equalTo(24)
        }
        
        self.refreshButton.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel)
            $0.right.equalTo(-24)
            $0.size.equalTo(50)
        }
        
        self.stackview.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(29)
        }
    }
    
    private func buttonFactory(named: String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: named), for: .normal)
        btn.layer.borderColor = UIColor.grey3().cgColor
        btn.layer.borderWidth = 1
        return btn
    }
    
    private func emptyViewFactory() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        return view
    }
}

fileprivate extension UIButton {
    func selected(named: String) {
        self.setImage(UIImage(named: named), for: .normal)
        self.layer.borderColor = UIColor.blue.cgColor
    }
}

