//
//  OperatingHoursSetView.PickerView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/02.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

extension OperatingHoursSetView {
    final class PickerView: UIView {
        private let pickerDate: UIDatePicker = {
            let pick = UIDatePicker()
            pick.locale = Locale(identifier: "ko")
            pick.setValue(UIColor.white, forKey: "textColor")
            pick.datePickerMode = .time
            return pick
        }()

        private let confirmButton: UIButton = {
            let button = UIButton()
            button.setTitle("확인", for: .normal)
            button.titleLabel?.font = .bold(size: 16)
            button.backgroundColor = .blue()
            return button
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            self.setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            self.addSubview(self.pickerDate)
            self.addSubview(self.confirmButton)
            
            self.pickerDate.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.top.equalToSuperview()
                $0.bottom.equalTo(self.confirmButton.snp.top)
            }
            
            self.confirmButton.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

