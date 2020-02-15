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
    private let stackView: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .vertical
        return stkView
    }()
    
    private let logo = UIImageView(image: UIImage(named: "splashIcon"))
    private lazy var empty1 = emptyViewFactory()
    private let titleImage = UIImageView(image: UIImage(named: "group13Copy"))
    private lazy var empty2 = emptyViewFactory()
    private let subTitleImage = UIImageView(image: UIImage(named: "splashName"))
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.view.backgroundColor = .blue()
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.logo)
        self.stackView.addArrangedSubview(self.empty1)
        self.stackView.addArrangedSubview(self.titleImage)
        self.stackView.addArrangedSubview(self.empty2)
        self.stackView.addArrangedSubview(self.subTitleImage)
        
        self.stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.empty1.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
        self.empty2.snp.makeConstraints {
            $0.height.equalTo(10)
        }
    }
    
    private func emptyViewFactory() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
