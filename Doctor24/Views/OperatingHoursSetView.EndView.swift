//
//  OperatingHoursSetView.EndView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

extension OperatingHoursSetView {
    final class EndView: UIView {
        let endTimeButton: UIButton = {
            let btn = UIButton()
            return btn
        }()
        
        let endStackView: UIStackView = {
            let stkView = UIStackView()
            stkView.axis = .horizontal
            stkView.alignment = .center
            stkView.spacing = 4
            return stkView
        }()
        
        let endTimeLabel: UILabel = {
            let label = UILabel()
            label.text = "오전 09:00"
            label.font = .bold(size: 22)
            label.textColor = .black()
            return label
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            self.setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            self.addSubview(self.endStackView)
            self.addSubview(self.endTimeButton)
            self.endStackView.addArrangedSubview(self.endTimeLabel)
            
            self.endTimeButton.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
            self.endStackView.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
}


