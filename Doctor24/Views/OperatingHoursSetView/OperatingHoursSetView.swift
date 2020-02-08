//
//  OperatingHoursSetView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OperatingHoursSetView: BaseView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    let pickerView: PickerView = {
        let view = PickerView()
        view.backgroundColor = .black()
        view.alpha = 0.0
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grey3()
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "진료시간"
        label.font = .bold(size: 14)
        label.textColor = .grey1()
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    private let operatingStackView: UIStackView = {
        let stkView = UIStackView()
        stkView.spacing = 22
        stkView.axis = .horizontal
        stkView.alignment = .center
        stkView.backgroundColor = .red
        return stkView
    }()
    
    private let operatingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let startView: StartView = {
        let view = StartView()
        view.able(true)
        return view
    }()
    
    private let endView: EndView = {
        let view = EndView()
        view.able(false)
        return view
    }()
    
    private let spacingLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .bold(size: 22)
        label.textColor = .black()
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
        self.backgroundColor = .clear
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        TodocInfo.shared.startTimeFilter
            .unwrap()
            .map { $0.convertDate }
            .subscribe(onNext: { [weak self] str in
                self?.startView.startTimeLabel.text = str
            }).disposed(by: self.disposeBag)
        
        TodocInfo.shared.endTimeFilter
            .unwrap()
            .map { $0.convertDate }
            .subscribe(onNext: { [weak self] str in
                self?.endView.endTimeLabel.text = str
            }).disposed(by: self.disposeBag)
        
        self.startView.startTimeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.startView.able(true)
                self.endView.able(false)
                
            }).disposed(by: self.disposeBag)
        
        self.endView.endTimeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.startView.able(false)
                self.endView.able(true)
                
            }).disposed(by: self.disposeBag)
        
        self.pickerView.confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
            
        }).disposed(by:self.disposeBag)
    }
}

// MARK: Private
extension OperatingHoursSetView {
    private func addSubviews() {
        self.addSubview(self.contentView)
        self.operatingStackView.addArrangedSubview(self.startView)
        self.operatingStackView.addArrangedSubview(self.spacingLabel)
        self.operatingStackView.addArrangedSubview(self.endView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.operatingBackgroundView)
        self.contentView.addSubview(self.operatingStackView)
        self.contentView.addSubview(self.pickerView)
    }
    
    private func setLayout() {
        self.lineView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
        
        self.closeButton.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.left.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(23)
        }
        
        self.contentView.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.lineView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        self.operatingBackgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.closeButton.snp.bottom).offset(11)
            $0.width.equalTo(327)
            $0.height.equalTo(52)
        }
        
        self.operatingStackView.snp.makeConstraints{
            $0.center.equalTo(self.operatingBackgroundView)
        }
        
        self.pickerView.snp.makeConstraints {
            $0.top.equalTo(self.operatingBackgroundView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
