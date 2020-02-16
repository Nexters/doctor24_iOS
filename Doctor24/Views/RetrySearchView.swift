//
//  RetrySearchView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/08.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

final class RetrySearchView: UIView {
    let button = UIButton()
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "refresh")
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "재탐색"
        label.font = .regular(size: 16)
        label.textColor = .grey1()
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.alpha = 0
        self.addSubviews()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hidden(_ hide: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.alpha = 0
            } else {
                self.alpha = 1
            }
        }, completion: { (finished) in
            self.isHidden = hide
        })
        
    }
}

extension RetrySearchView {
    private func addSubviews() {
        self.addSubview(self.image)
        self.addSubview(self.titleLabel)
        self.addSubview(self.button)
    }
    
    private func setLayout() {
        self.image.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.left.equalToSuperview().offset(19)
            $0.centerY.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.left.equalTo(self.image.snp.right).offset(11)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        self.button.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}
