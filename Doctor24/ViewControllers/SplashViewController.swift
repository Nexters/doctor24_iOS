//
//  SplashViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/16.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let logo = UIImageView(image: UIImage(named: "splashIcon"))
    private let titleImage = UIImageView(image: UIImage(named: "group13Copy"))
    private let subTitleImage = UIImageView(image: UIImage(named: "splashName"))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.view.backgroundColor = .blue()
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.logo)
        self.contentView.addSubview(self.titleImage)
        self.contentView.addSubview(self.subTitleImage)

        self.contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(128)
            $0.height.equalTo(179)
        }
        
        self.logo.snp.makeConstraints {
            $0.size.equalTo(111)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        self.titleImage.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.logo.snp.bottom).offset(16)
        }
        
        self.subTitleImage.snp.makeConstraints {
            $0.top.equalTo(self.titleImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
