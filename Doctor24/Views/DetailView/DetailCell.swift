//
//  DetailCell.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/07.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit

final class DetailHeaderView: UICollectionReusableView, FacilityTitleable {
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis      = .vertical
        stack.alignment = .leading
        stack.spacing   = 8
        return stack
    }()
    
    private let typeView: UIImageView = UIImageView()
    private let hospitalTitle: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textColor = .black()
        label.numberOfLines = 2
        return label
    }()
    
    private let dateStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis      = .horizontal
        stkView.alignment = .leading
        stkView.spacing   = 8
        return stkView
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
    
    private let navigationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "navigation"), for: .normal)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setData(data: Model.Todoc.DetailFacility) {
        if let type = self.typeImg(with: data) {
            self.typeView.isHidden = false
            self.typeView.image = type
        } else {
            self.typeView.isHidden = true
        }
        
        self.hospitalTitle.text = data.name
        self.timeLabel.text  = "\(data.today.startTime.convertDate) ~ \(data.today.endTime.convertDate)"
    }
    
    private func setupUI(){
        self.backgroundColor = .red
        self.addSubview(self.titleStackView)
        self.addSubview(self.navigationButton)
        self.addSubview(self.lineView)
        self.titleStackView.addArrangedSubview(self.typeView)
        self.titleStackView.addArrangedSubview(self.hospitalTitle)
        self.titleStackView.addArrangedSubview(self.dateStack)
        self.dateStack.addArrangedSubview(self.todayLabel)
        self.dateStack.addArrangedSubview(self.timeLabel)
        
        self.navigationButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.top.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.titleStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(self.lineView.snp.top).offset(-23.5)
        }
        
        self.lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DetailLineHeader: UICollectionReusableView {
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
    }
}

protocol DetailCellData where Self: UICollectionViewCell {
    func setData(type: DetailView.DetailCellType)
}

final class DetailNormalCell: UICollectionViewCell, DetailCellData, FacilityTitleable {
    private let imageView = UIImageView()
    private let content: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(type: DetailView.DetailCellType) {
        switch type {
        case .hospitalType(let title):
            self.imageView.image = UIImage(named: "hospitalType")
            self.content.text = title
            
        case .phone(let number):
            self.imageView.image = UIImage(named: "phoneNumber")
            self.content.text = number
        default:
            break
        }
    }
    
    private func setupUI() {
        self.backgroundColor = .blue
        self.addSubview(self.imageView)
        self.addSubview(self.content)
        
        self.imageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.left.equalTo(24)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(0)
        }
        
        self.content.snp.makeConstraints {
            $0.centerY.equalTo(self.imageView)
            $0.left.equalTo(self.imageView.snp.right).offset(6)
        }
    }
}

final class DetailDayCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "time")
        return imgView
    }()
    
    private let dayTitle: UILabel = {
        let label = UILabel()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(day: String?, time: String?) {
        if let day = day, let time = time {
            self.imageView.isHidden = false
            self.dayTitle.isHidden = false
            self.timeLabel.isHidden = false
            
            self.dayTitle.text = day
            self.timeLabel.text = time
        } else {
            self.imageView.isHidden = true
            self.dayTitle.isHidden = true
            self.timeLabel.isHidden = true
        }
    }
    
    private func setupUI() {
        self.backgroundColor = .yellow
        self.addSubview(self.imageView)
        self.addSubview(self.dayTitle)
        self.addSubview(self.timeLabel)
        
        self.imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.size.equalTo(24)
        }
        
        self.dayTitle.snp.makeConstraints {
            $0.centerY.equalTo(self.imageView)
            $0.left.equalTo(self.imageView.snp.right).offset(6)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.dayTitle.snp.bottom).offset(4)
            $0.left.equalTo(self.dayTitle.snp.left)
            $0.right.equalToSuperview().offset(-28)
            $0.bottom.equalToSuperview()
        }
    }
}

final class DetailDistanceCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "address")
        return imgView
    }()
    
    private let distance: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(distance: String, address: String) {
        self.distance.text = distance
        self.address.text  = address
    }
    
    private func setupUI() {
        self.backgroundColor = .purple
        self.addSubview(self.imageView)
        self.addSubview(self.distance)
        self.addSubview(self.address)
        
        self.imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.size.equalTo(24)
        }
        
        self.distance.snp.makeConstraints {
            $0.centerY.equalTo(self.imageView)
            $0.left.equalTo(self.imageView.snp.right).offset(6)
        }
        
        self.address.snp.makeConstraints {
            $0.left.equalTo(self.distance)
            $0.top.equalTo(self.distance.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}
