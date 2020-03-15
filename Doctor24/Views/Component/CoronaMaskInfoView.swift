//
//  CoronaMaskInfoView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CoronaMaskInfoView: UIView {
    // MARK: Properties
    public let isShowStock = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "100곳"
        label.textColor = .white()
        label.font = .bold(size: 22)
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "해당 위치\n마스크 구매 가능 지점"
        label.numberOfLines = 0
        label.textColor = .white()
        label.font = .bold(size: 14)
        return label
    }()
    
    private let stockButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.bold(size: 14)
        btn.layer.borderColor = UIColor.blue().cgColor
        btn.backgroundColor = .white()
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 2
        return btn
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupUI()
        self.setBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .darkBlue()
        self.addSubview(self.descLabel)
        self.addSubview(self.countLabel)
        self.addSubview(self.stockButton)
        
        self.descLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.stockButton)
            $0.left.equalToSuperview().offset(24)
        }
        
        self.countLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.stockButton)
            $0.width.equalTo(84)
            $0.right.equalTo(self.stockButton.snp.left).offset(-21)
        }
        
        self.stockButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.width.equalTo(78)
            $0.height.equalTo(36)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    private func setBind() {
        self.isShowStock
            .subscribe(onNext: { [weak self] isToggle in
                if isToggle {
                    self?.stockButton.layer.borderColor = UIColor.blue().cgColor
                    self?.stockButton.backgroundColor = .white()
                    self?.stockButton.setTitle("재고 ON", for: .normal)
                    self?.stockButton.setTitleColor(.blue(), for: .normal)
                } else {
                    self?.stockButton.layer.borderColor = UIColor.grey2().cgColor
                    self?.stockButton.backgroundColor = .grey4()
                    self?.stockButton.setTitle("재고 OFF", for: .normal)
                    self?.stockButton.setTitleColor(.grey2(), for: .normal)
                }
            }).disposed(by: self.disposeBag)
        
        self.stockButton.rx.tap
            .withLatestFrom(self.isShowStock)
            .map { $0 ? false : true }
            .bind(to: self.isShowStock)
            .disposed(by: self.disposeBag)
    }
}


