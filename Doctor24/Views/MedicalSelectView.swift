//
//  MedicalSelectView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/26.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import RxSwift
import RxCocoa

final class MedicalSelectView: BaseView {
    // MARK: Properties
    let medicalType = BehaviorRelay<Model.Todoc.MedicalType>(value: .hospital)
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let hospital: UIButton = {
        let button = UIButton()
        button.setTitle("병원", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let pharmacy: UIButton = {
        let button = UIButton()
        button.setTitle("약국", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stk = UIStackView()
        stk.axis = .horizontal
        stk.distribution = .fillEqually
        return stk
    }()
    
    private let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        return view
    }()
    
    private let selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "병원"
        label.textColor = .black
        return label
    }()
    
    required init(controlBy viewController: BaseViewController) {
        super.init(controlBy: viewController)
        self.setupUI()
        self.setBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        self.hospital.rx.tap.do(onNext: { [weak self] in
                self?.animateSelectHospital()
            })
            .map { Model.Todoc.MedicalType.hospital }
            .bind(to: self.medicalType)
            .disposed(by: self.disposeBag)
        
        self.pharmacy.rx.tap
            .do(onNext: { [weak self] in
                self?.animateSelectPharmacy()
            })
            .map { Model.Todoc.MedicalType.pharmacy }
            .bind(to: self.medicalType)
            .disposed(by: self.disposeBag)
    }
}

extension MedicalSelectView {
    private func addSubviews() {
        self.addSubview(self.buttonStackView)
        self.addSubview(self.selectedView)
        self.buttonStackView.addArrangedSubview(self.hospital)
        self.buttonStackView.addArrangedSubview(self.pharmacy)
        self.selectedView.addSubview(self.selectedLabel)
    }
    
    private func setLayout() {
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.selectedView.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(46)
            $0.top.equalToSuperview().offset(6)
            $0.left.equalToSuperview().offset(6)
        }
        
        self.selectedLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func animateSelectHospital() {
        self.layoutIfNeeded()
        self.selectedView.snp.remakeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(46)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(6)
        }
        self.selectedLabel.text = "병원"
        UIView.animate(withDuration: 0.1, animations: {
            self.selectedView.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            
        })
    }
    
    private func animateSelectPharmacy() {
        self.layoutIfNeeded()
        self.selectedView.snp.remakeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(46)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(self.frame.width/2)
        }
        self.selectedLabel.text = "약국"
        UIView.animate(withDuration: 0.1, animations: {
            self.selectedView.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            
        })
    }
}
