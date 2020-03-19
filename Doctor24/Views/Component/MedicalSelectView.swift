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
import Toast_Swift

final class MedicalSelectView: BaseView {
    // MARK: Properties
    var isMedicalLock = false
    let medicalType = BehaviorRelay<Model.Todoc.MedicalType>(value: .hospital)
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let hospital: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private let hospitalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "병원"
        label.textColor = .grey3()
        label.font = .bold(size: 16)
        
        return label
    }()
    
    private let hopitalImage = UIImageView(image: UIImage(named: "toggleHospitalEnable"))

    private let drugTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "약국"
        label.textColor = .grey3()
        label.font = .bold(size: 16)
        return label
    }()
    
    private let drugImage = UIImageView(image: UIImage(named: "toggleDrugEnable"))
    
    private let pharmacy: UIButton = {
        let button = UIButton()
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
        view.backgroundColor = .blue()
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        view.setShadow(radius: 22,
                       shadowColor: UIColor(red: 2, green: 35, blue: 183, alpha: 0.77),
                       shadowOffset: CGSize(width: 0, height: 2),
                       shadowBlur: 6)
        return view
    }()
    
    private let selectedImageView = UIImageView(image: UIImage(named: "toggleHospitalActive"))
    
    private let selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "병원"
        label.textColor = .white()
        label.font = UIFont.bold(size:16)
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
        self.hospital.rx.tap
            .filter{ self.isMedicalLock == false }
            .do(onNext: { [weak self] in
                self?.animateSelectHospital()
            })
            .map { Model.Todoc.MedicalType.hospital }
            .bind(to: self.medicalType)
            .disposed(by: self.disposeBag)
        
        self.pharmacy.rx.tap
            .filter{ self.isMedicalLock == false }
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
        self.addSubview(self.hopitalImage)
        self.addSubview(self.hospitalTitleLabel)
        self.addSubview(self.drugImage)
        self.addSubview(self.drugTitleLabel)
        self.addSubview(self.buttonStackView)
        self.addSubview(self.selectedView)
        
        self.buttonStackView.addArrangedSubview(self.hospital)
        self.buttonStackView.addArrangedSubview(self.pharmacy)
        
        self.selectedView.addSubview(self.selectedImageView)
        self.selectedView.addSubview(self.selectedLabel)
    }
    
    private func setLayout() {
        self.buttonStackView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.selectedView.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(46)
            $0.top.equalToSuperview().offset(6)
            $0.left.equalToSuperview().offset(6)
        }
        
        self.selectedLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(self.selectedImageView.snp.right).offset(4)
        }
        
        self.selectedImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
        }
        
        self.hopitalImage.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        self.hospitalTitleLabel.snp.makeConstraints {
            $0.left.equalTo(self.hopitalImage.snp.right).offset(4)
            $0.centerY.equalToSuperview()
        }
        
        self.drugImage.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(self.pharmacy).offset(14)
        }
        
        self.drugTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(self.drugImage.snp.right).offset(4)
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
        self.selectedImageView.image = UIImage(named: "toggleHospitalActive")
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.selectedView.superview?.layoutIfNeeded()
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
        self.selectedImageView.image = UIImage(named: "toggleDrugActive")
        self.selectedLabel.text = "약국"
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.selectedView.superview?.layoutIfNeeded()
        })
    }
}
