//
//  PreviewFacilityView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/04.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import CoreLocation
import SnapKit
import RxSwift
import RxCocoa


final class PreviewFacilityView: BaseView, FacilityTitleable, MapSelectable {
    
    // MARK: Property
    var facility: Model.Todoc.PreviewFacility!
    private var phoneNumber: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    let titleStack: UIStackView = {
        let stk = UIStackView()
        stk.axis = .vertical
        stk.alignment = .leading
        stk.spacing = 8
        return stk
    }()
    
    private let contentStack: UIStackView = {
        let stk = UIStackView()
        stk.axis = .vertical
        stk.alignment = .leading
        return stk
    }()
    
    private let hospitalTypeStack: UIStackView = {
        let stk = UIStackView()
        stk.axis = .horizontal
        stk.spacing = 3
        stk.alignment = .center
        return stk
    }()
    
    private let distanceStackView: UIStackView = {
        let stk = UIStackView()
        stk.axis = .horizontal
        stk.alignment = .center
        stk.spacing = 3
        return stk
    }()
    
    private let distanceContentStackView: UIStackView = {
        let stk = UIStackView()
        stk.axis = .horizontal
        stk.alignment = .leading
        return stk
    }()
    
    private let typeStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .horizontal
        stkView.spacing = 6
        return stkView
    }()
    
    private let emergency: UIImageView = UIImageView(image: UIImage(named: "emergencyType"))
    private let night: UIImageView = UIImageView(image: UIImage(named: "nightType"))
    private let normal: UIImageView = UIImageView(image: UIImage(named: "nomal"))
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white()
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grey3()
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font          = .bold(size: 20)
        label.textColor     = .black()
        label.numberOfLines = 2
        return label
    }()
    
    private let navigationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "navigation"), for: .normal)
        return button
    }()
    
    private let todayLabel: UILabel = {
        let label  = UILabel()
        label.text = "오늘"
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오전 9:00 ~ 오후 7:00"
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    private let heightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let hopitalImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "hospitalType")
        return imgView
    }()
    
    private let hopitalCategories: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let heightView2: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    private let heightView3: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let addressView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "address")
        return imgView
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        label.text = "203km"
        return label
    }()
    
    let addreeLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 강남구 강남대로 102길 38"
        label.font = .regular(size: 16)
        label.textColor = .black()
        label.numberOfLines = 1
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("전화하기", for: .normal)
        button.setTitleColor(.white(), for: .normal)
        button.setTitle("전화번호 정보가 없습니다.", for: .disabled)
        button.setTitleColor(.grey2(), for: .disabled)

        button.backgroundColor = .blue()
        button.titleLabel?.font = .bold(size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let callBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        self.backgroundColor = .clear
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        self.callButton.rx.tap.subscribe(onNext: {
                guard let url = URL(string: "tel://\(self.phoneNumber.onlyDigits())"),
                    UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
        }).disposed(by: self.disposeBag)
        
        self.navigationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectMap(latitude: self.facility.latitude, longitude: self.facility.longitude, title: self.facility.name)
            }).disposed(by: self.disposeBag)
    }
    
    public func setData(facility: Model.Todoc.PreviewFacility) {
        if let number = facility.phone {
            self.phoneNumber = number
            self.callButton.isEnabled = true
            self.callButton.backgroundColor = .blue()
        } else {
            self.callButton.isEnabled = false
            self.callButton.backgroundColor = .grey3()
        }
        
        self.facility = facility
        self.titleLabel.text = facility.name
        self.timeLabel.text  = "\(facility.day.startTime.convertDate) ~ \(facility.day.endTime.convertDate)"
        self.addreeLabel.text = facility.address
        self.distanceLabel.text = self.distance(lat: facility.latitude, long: facility.longitude)
        
        if let category = self.category(with: facility) {
            lineView2.isHidden = false
            hospitalTypeStack.isHidden = false
            heightView2.isHidden = false
            hopitalCategories.text = category
        } else {
            lineView2.isHidden = true
            hospitalTypeStack.isHidden = true
            heightView2.isHidden = true
        }
        
        guard facility.medicalType == .hospital else {
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = true
            return
        }
        
        switch (facility.nightTimeServe, facility.emergency) {
        case (true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            
        case (false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden  = true
            
        case (true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            
        default:
            self.normal.isHidden = false
            self.emergency.isHidden = true
            self.night.isHidden = true
        }
    }
}

extension PreviewFacilityView {
    private func addSubviews() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.bottomView)
        self.contentView.addSubview(self.titleStack)
        self.contentView.addSubview(self.contentStack)
        self.contentView.addSubview(self.typeStack)
        self.typeStack.addArrangedSubview(self.normal)
        self.typeStack.addArrangedSubview(self.emergency)
        self.typeStack.addArrangedSubview(self.night)
        self.titleStack.addArrangedSubview(titleLabel)
        
        self.contentStack.addArrangedSubview(lineView)
        self.contentStack.addArrangedSubview(heightView)
        self.contentStack.addArrangedSubview(distanceStackView)
        self.contentStack.addArrangedSubview(distanceContentStackView)
        self.contentStack.addArrangedSubview(heightView3)
        self.contentStack.addArrangedSubview(lineView2)
        self.contentStack.addArrangedSubview(heightView2)
        self.contentStack.addArrangedSubview(hospitalTypeStack)
        
        self.hospitalTypeStack.addArrangedSubview(hopitalImgView)
        self.hospitalTypeStack.addArrangedSubview(hopitalCategories)
        
        self.distanceStackView.addArrangedSubview(addressView)
        self.distanceStackView.addArrangedSubview(distanceLabel)
        self.distanceContentStackView.addArrangedSubview(addreeLabel)
        
        self.contentView.addSubview(navigationButton)
        self.contentView.addSubview(todayLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(self.callBackGroundView)
        self.contentView.addSubview(callButton)
    }
    
    private func setLayout() {
        
        self.typeStack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(32)
        }
        
        self.titleStack.snp.makeConstraints {
            $0.top.equalTo(self.typeStack.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(self.navigationButton.snp.left).offset(10)
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
        
        self.navigationButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.centerY.equalTo(self.titleLabel)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.todayLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleStack.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleStack.snp.bottom).offset(8)
            $0.left.equalTo(self.todayLabel.snp.right).offset(8)
        }
        
        self.contentStack.snp.makeConstraints {
            $0.top.equalTo(self.todayLabel.snp.bottom).offset(15.5)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.lineView2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
        }
        
        self.heightView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(14.5)
        }
        
        self.heightView2.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(14.5)
        }
        
        self.heightView3.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(11.5)
        }
        
        self.distanceLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        self.addreeLabel.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(30)
        }
        
        self.callBackGroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(self.callButton)
        }
        
        self.callButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.safeArea.bottom).offset(-16)
        }
    }
}
