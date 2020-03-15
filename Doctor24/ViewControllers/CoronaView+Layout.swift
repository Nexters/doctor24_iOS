//
//  CoronaView+Layout.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//

import Domain
import UIKit

import SnapKit
import NMapsMap

extension CoronaView {
    func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.closeButton)
        self.addSubview(self.coronaTag)
        self.addSubview(self.maskInfo)
        self.addSubview(self.cameraButton)
        self.addSubview(self.retrySearchView)
    }
    
    func setLayout() {
        self.mapControlView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(self.safeArea.top).offset(20)
            $0.size.equalTo(44)
        }
        
        self.coronaTag.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.top.equalTo(self.closeButton.snp.bottom).offset(16)
        }
        
        self.maskInfo.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(self.bottomSafeAreaInset + 72)
        }
        
        self.cameraButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(self.maskInfo.snp.top).offset(-24)
            $0.size.equalTo(58)
        }
        
        self.retrySearchView.snp.makeConstraints {
            $0.top.equalTo(self.coronaTag.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(110)
            $0.height.equalTo(44)
        }
    }
}
