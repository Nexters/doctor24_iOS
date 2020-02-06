//
//  TopBar.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/07.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

final class TopBar: UIView {
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black()
        label.text = "토닥ㄷ토닥"
        label.font = UIFont.regular(size: 18)
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.addSubviews()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
extension TopBar {
    private func addSubviews() {
        self.addSubview(self.closeButton)
        self.addSubview(self.titleLabel)
    }
    
    private func setLayout() {
        self.closeButton.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.closeButton)
            $0.centerX.equalToSuperview()
        }
    }
}
