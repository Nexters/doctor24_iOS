//
//  ClusterCell.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/11.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit

final class ClusterCell: UITableViewCell, FacilityTitleable {
    private let topLineView: UIView = {
        let line = UIView()
        line.backgroundColor = .grey4()
        return line
    }()
    
    private let typeStack: UIStackView = {
        let stkView = UIStackView()
        stkView.spacing = 6
        stkView.distribution = .fill
        stkView.axis = .horizontal
        return stkView
    }()
    
    private let emergency: UIImageView = UIImageView(image: UIImage(named: "emergencyType"))
    private let night: UIImageView = UIImageView(image: UIImage(named: "nightType"))
    private let normal: UIImageView = UIImageView(image: UIImage(named: "nomal"))
    private let corona: UIImageView = UIImageView(image: UIImage(named: "coronaBadge"))
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 18)
        label.textColor = .black()
        label.numberOfLines = 0
        return label
    }()
    
    private let dayStack: UIStackView = {
        let stkView = UIStackView()
        stkView.spacing = 8
        stkView.axis = .horizontal
        stkView.alignment = .leading
        return stkView
    }()
    
    private let today: UILabel = {
        let label = UILabel()
        label.text = "오늘"
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(facility: Model.Todoc.PreviewFacility) {
        
        self.titleLabel.text = facility.name
        self.timeLabel.text = "\(facility.day.startTime.convertDate) ~ \(facility.day.endTime.convertDate)"
        guard facility.medicalType == .hospital || facility.medicalType == .corona else { return }
        
        switch (facility.nightTimeServe, facility.emergency, facility.medicalType == .corona) {
        case (true, true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            self.corona.isHidden = false
            
        case (true, true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            self.corona.isHidden = true
        
        case (false, true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = true
            self.corona.isHidden = false
            
        case (false, true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = true
            self.corona.isHidden = true
            
        case (true, false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            self.corona.isHidden = false
            
        case (true, false, false):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            self.corona.isHidden = true
            
        case (false, false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = true
            self.corona.isHidden = false
            
        case (false, false, false):
            self.normal.isHidden = false
            self.emergency.isHidden = true
            self.night.isHidden = true
            self.corona.isHidden = true
        }
    }
    
    private func setupUI() {
        self.normal.isHidden = true
        self.emergency.isHidden = true
        self.night.isHidden = true
        self.corona.isHidden = true
        
        self.backgroundColor = .clear
        self.addSubview(self.topLineView)
        self.addSubview(self.typeStack)
        self.addSubview(self.titleLabel)
        self.addSubview(self.dayStack)
        
        self.topLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        self.typeStack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(self.topLineView.snp.bottom).offset(15.5)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(self.typeStack.snp.bottom).offset(8)
        }
        
        self.dayStack.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-15.5)
        }
        
        self.emergency.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(20)
        }
        
        self.night.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(20)
        }
        
        self.normal.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(20)
        }
        
        self.typeStack.addArrangedSubview(self.corona)
        self.typeStack.addArrangedSubview(self.emergency)
        self.typeStack.addArrangedSubview(self.night)
        self.typeStack.addArrangedSubview(self.normal)
        
        self.dayStack.addArrangedSubview(self.today)
        self.dayStack.addArrangedSubview(self.timeLabel)

    }
}
