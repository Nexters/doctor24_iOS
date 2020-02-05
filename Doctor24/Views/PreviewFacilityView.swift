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


final class PreviewFacilityView: BaseView {
    // MARK: Property
    var facility: Model.Todoc.PreviewFacility!
    private var phoneNumber: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let titleStack: UIStackView = {
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
    
    private let typeImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
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
        label.text          = "서울자이청소년과약국서울자이창소년과약국"
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
    
    private let addreeLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 강남구 강남대로 102길 38"
        label.font = .regular(size: 16)
        label.textColor = .black()
        label.numberOfLines = 0
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("전화하기", for: .normal)
        button.setTitleColor(.white(), for: .normal)
        button.backgroundColor = .blue()
        button.titleLabel?.font = .bold(size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
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
    }
    
    public func setData(facility: Model.Todoc.PreviewFacility) {
        self.facility = facility
        self.titleLabel.text = facility.name
        self.timeLabel.text  = "\(facility.day.startTime.convertDate) ~ \(facility.day.endTime.convertDate)"
        self.addreeLabel.text = facility.address
        self.phoneNumber     = facility.phone
        self.distanceLabel.text = self.distance(lat: facility.latitude, long: facility.longitude)
        
        if let category = self.category(with: facility) {
            lineView.isHidden = false
            heightView.isHidden = false
            hospitalTypeStack.isHidden = false
            heightView2.isHidden = false
            hopitalCategories.text = category
        } else {
            lineView.isHidden = true
            heightView.isHidden = true
            hospitalTypeStack.isHidden = true
            heightView2.isHidden = true
        }
        
        if let type = self.typeImg(with: facility) {
            self.typeImgView.isHidden = false
            self.typeImgView.image = type
        } else {
            self.typeImgView.isHidden = true
        }
    }
}

extension PreviewFacilityView {
    private func addSubviews() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(bottomView)
        self.contentView.addSubview(titleStack)
        self.contentView.addSubview(self.contentStack)
        
        self.titleStack.addArrangedSubview(typeImgView)
        self.titleStack.addArrangedSubview(titleLabel)
        
        self.contentStack.addArrangedSubview(lineView)
        self.contentStack.addArrangedSubview(heightView)
        self.contentStack.addArrangedSubview(hospitalTypeStack)
        self.contentStack.addArrangedSubview(heightView2)
        self.contentStack.addArrangedSubview(lineView2)
        self.contentStack.addArrangedSubview(heightView3)
        self.contentStack.addArrangedSubview(distanceStackView)
        self.contentStack.addArrangedSubview(distanceContentStackView)
        
        self.hospitalTypeStack.addArrangedSubview(hopitalImgView)
        self.hospitalTypeStack.addArrangedSubview(hopitalCategories)
        
        self.distanceStackView.addArrangedSubview(addressView)
        self.distanceStackView.addArrangedSubview(distanceLabel)
        self.distanceContentStackView.addArrangedSubview(addreeLabel)
        
        self.contentView.addSubview(navigationButton)
        self.contentView.addSubview(todayLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(callButton)
    }
    
    private func setLayout() {
        self.titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(self.navigationButton.snp.left).offset(10)
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
        
        self.navigationButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.top.equalToSuperview().offset(33)
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
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.lineView2.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        self.heightView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(11.5)
        }
        
        self.heightView2.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(11.5)
        }
        
        self.heightView3.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(11.5)
        }
        
        self.distanceLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        self.addreeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(30)
            $0.right.equalToSuperview()
        }
        
        self.callButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.safeArea.bottom).offset(-16)
        }
    }
}


extension PreviewFacilityView {
    private func distance(lat: Double, long: Double) -> String {
        if let current = try? TodocInfo.shared.currentLocation.value() {
            let currentLoc = CLLocation(latitude: current.latitude, longitude: current.longitude)
            let distance = currentLoc.distance(from: CLLocation(latitude: lat, longitude: long))
            
            return "\(Int(distance) / 1000)km"
        }
        
        return "km"
    }
    
    private func typeImg(with facility: Model.Todoc.PreviewFacility) -> UIImage? {
        guard facility.medicalType == .hospital else { return nil }
        switch (facility.nightTimeServe, facility.emergency) {
        case (true, _):
            return UIImage(named: "nightType")
            
        case (false, true):
            return UIImage(named: "emergencyType")
        default:
            return nil
        }
    }
    
    private func category(with facility: Model.Todoc.PreviewFacility) -> String? {
        guard let categories = facility.categories, categories.count > 0 else { return nil }
        let categoriesNoWhiteSpc = categories.map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        
        return categoriesNoWhiteSpc.joined(separator: ", ")
    }
}
