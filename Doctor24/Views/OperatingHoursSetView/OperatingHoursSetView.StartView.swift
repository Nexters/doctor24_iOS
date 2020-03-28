//
//  OperatingHoursSetView.StartView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

extension OperatingHoursSetView {
    final class StartView: UIView {
        let startTimeButton: UIButton = {
            let btn = UIButton()
            return btn
        }()
        
        let startStackView: UIStackView = {
            let stkView = UIStackView()
            stkView.axis = .horizontal
            stkView.alignment = .center
            stkView.spacing = 4
            return stkView
        }()
        
        let startTimeLabel: UILabel = {
            let label = UILabel()
            label.font = .bold(size: 26)
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
        
        func able(_ able: Bool) {
            if able {
                startTimeLabel.textColor = .black()
            } else {
                startTimeLabel.textColor = .grey3()
            }
        }
        
        private func setupUI() {
            self.addSubview(self.startStackView)
            self.addSubview(self.startTimeButton)
            self.startStackView.addArrangedSubview(self.startTimeLabel)
            
            self.startTimeButton.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
            
            self.startStackView.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
}
