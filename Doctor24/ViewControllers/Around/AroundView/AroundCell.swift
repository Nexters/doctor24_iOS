//
//  AroundCell.swift
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

final class AroundCell: UITableViewCell, FacilityTitleable, MapSelectable, Badgeable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    private var disposeBag = DisposeBag()
    
    private let contentStackView: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .vertical
        stkView.spacing = 4
        return stkView
    }()
    
    private let dayStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .horizontal
        stkView.alignment = .leading
        stkView.spacing = 8
        return stkView
    }()
    
    private let typeStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .horizontal
        stkView.spacing = 6
        return stkView
    }()
    
    var emergency: UIImageView = UIImageView(image: UIImage(named: "emergencyType"))
    var night: UIImageView = UIImageView(image: UIImage(named: "nightType"))
    var normal: UIImageView = UIImageView(image: UIImage(named: "nomal"))
    var corona: UIImageView = UIImageView(image: UIImage(named: "coronaBadge"))
    var secure: UIImageView = UIImageView(image: UIImage(named: "secureBadge"))
    
    private let type: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 18)
        label.textColor = .black()
        return label
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        label.text = "오늘"
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .grey1()
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    private let naviButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "navigation"), for: .normal)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(facility: Model.Todoc.PreviewFacility) {
        self.naviButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectMap(latitude: facility.latitude, longitude: facility.longitude, title: facility.name)
        }).disposed(by: self.disposeBag)
        
        self.titleLabel.text = facility.name
        self.dayLabel.text =  "\(facility.day.startTime.convertDate) ~ \(facility.day.endTime.convertDate)"
        self.distanceLabel.text = self.distance(lat: facility.latitude, long: facility.longitude)
        
        guard facility.medicalType == .hospital ||
              facility.medicalType == .corona ||
              facility.medicalType == .secure
        else { return }
        
        self.showBadge(night: facility.nightTimeServe,
                       emergency: facility.emergency,
                       corona: facility.medicalType == .corona,
                       secure: facility.medicalType == .secure)
    }
    
    private func setupUI() {
        self.normal.isHidden = true
        self.emergency.isHidden = true
        self.night.isHidden  = true
        self.corona.isHidden = true
        self.secure.isHidden = true
        
        self.backgroundColor = .clear
        self.addSubview(self.contentStackView)
        self.addSubview(self.naviButton)
        self.addSubview(self.typeStack)

        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.contentStackView.addArrangedSubview(self.dayStack)
        self.contentStackView.addArrangedSubview(self.distanceLabel)
        self.addSubview(self.lineView)
        
        self.titleLabel.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(18)
        }
        
        self.typeStack.addArrangedSubview(self.secure)
        self.typeStack.addArrangedSubview(self.corona)
        self.typeStack.addArrangedSubview(self.normal)
        self.typeStack.addArrangedSubview(self.night)
        self.typeStack.addArrangedSubview(self.emergency)
        self.dayStack.addArrangedSubview(self.todayLabel)
        self.dayStack.addArrangedSubview(self.dayLabel)
        
        self.typeStack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(16)
        }
        
        self.contentStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(self.typeStack.snp.bottom).offset(8)
            $0.right.equalTo(self.naviButton.snp.left).offset(-16)
        }
        
        self.lineView.snp.makeConstraints {
            $0.top.equalTo(self.contentStackView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.naviButton.snp.makeConstraints {
            $0.centerY.equalTo(self.contentStackView)
            $0.right.equalToSuperview().offset(-24)
            $0.size.equalTo(54)
        }
    }
}

final class AroundNoMoreCell: UITableViewCell {
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .grey2()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(contentLabel)
        self.contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23.5)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
