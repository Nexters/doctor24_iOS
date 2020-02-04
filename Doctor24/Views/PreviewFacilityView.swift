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
    private var phoneNumber: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
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
        self.titleLabel.text = facility.name
        self.timeLabel.text  = "\(facility.day.startTime.convertDate) ~ \(facility.day.endTime.convertDate)"
        self.addreeLabel.text = facility.address
        self.phoneNumber     = facility.phone
        self.distanceLabel.text = self.distance(lat: facility.latitude, long: facility.longitude)
    }
}

extension PreviewFacilityView {
    private func addSubviews() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(bottomView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(navigationButton)
        self.contentView.addSubview(todayLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(addressView)
        self.contentView.addSubview(distanceLabel)
        self.contentView.addSubview(addreeLabel)
        self.contentView.addSubview(callButton)
    }
    
    private func setLayout() {
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
        
        self.titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(self.bottomView.snp.bottom).offset(16)
            $0.right.equalTo(self.navigationButton.snp.left).offset(10)
        }
        
        self.navigationButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.top.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.todayLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.todayLabel.snp.right).offset(8)
        }
        
        self.lineView.snp.makeConstraints {
            $0.top.equalTo(self.todayLabel.snp.bottom).offset(23.5)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
        
        self.addressView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(self.lineView.snp.bottom).offset(11.5)
            $0.size.equalTo(24)
        }
        
        self.distanceLabel.snp.makeConstraints {
            $0.left.equalTo(self.addressView.snp.right).offset(6)
            $0.centerY.equalTo(self.addressView)
        }
        
        self.addreeLabel.snp.makeConstraints {
            $0.left.equalTo(self.distanceLabel.snp.left)
            $0.top.equalTo(self.distanceLabel.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(-24)
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
}
