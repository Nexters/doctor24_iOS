//
//  ViewMenuSeletable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/12.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

protocol ViewMenuSelectable: ViewMenuable where Self: BaseView {
    var backgroundView: UIView! { get }
}

extension ViewMenuSelectable {
    func setupBaseView() {
        self.addSubview(self.contentView)
        self.addSubview(self.backgroundView)
        
        self.contentView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(self.contentViewHeight)
        }
        
        self.backgroundView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(pressedBackView(_:)))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
}
