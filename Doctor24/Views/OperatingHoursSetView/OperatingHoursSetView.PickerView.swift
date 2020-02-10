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
        lazy var confirmButton: UIButton = {
            let button = UIButton()
            button.setTitle("확인", for: .normal)
            button.setTitleColor(.white(), for: .normal)
            button.setTitleColor(.grey2(), for: .disabled)
            button.titleLabel?.font = .bold(size: 16)
            button.backgroundColor = .blue()
            
            if haveSafeArea {
                button.layer.cornerRadius = 5
            }
            
            return button
        }()
        
        let pickerDate: UIDatePicker = {
            let pick = UIDatePicker()
            pick.locale = Locale(identifier: "ko")
            pick.setValue(UIColor.white, forKey: "textColor")
            pick.datePickerMode = .time
            return pick
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            self.setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func confirmButton(able: Bool) {
            self.confirmButton.isEnabled = able
            if able {
                self.confirmButton.backgroundColor = .blue()
            } else {
                self.confirmButton.backgroundColor = .grey3()
            }
        }
        
        private func setupUI() {
            self.addSubview(self.pickerDate)
            self.addSubview(self.confirmButton)
            
            self.pickerDate.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.top.equalToSuperview()
                $0.height.equalTo(198)
            }
            
            self.confirmButton.snp.makeConstraints {
                if haveSafeArea {
                    $0.left.equalToSuperview().offset(24)
                    $0.right.equalToSuperview().offset(-24)
                    $0.bottom.equalToSuperview().offset(-(self.bottomSafeAreaInset + 24))
                    $0.height.equalTo(56)
                } else {
                    $0.left.right.bottom.equalToSuperview()
                    $0.top.equalTo(self.pickerDate.snp.bottom)
                }
            }
        }
    }
}

