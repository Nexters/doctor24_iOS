//
//  SecureGuideViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/04.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SecureGuideViewController: FadeModalTransitionViewController {
    private let disposeBag = DisposeBag()
    
    // MARK: UI Componenet
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white()
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    private let centerImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "securePopup")
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "국민안심병원이란?"
        label.font = .bold(size: 18)
        label.textColor = .black()
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "코로나19의 병원 내 감염을 막기 위해\n호흡기 환자와 비호흡기 환자의\n진료 과정을 분리한 병원입니다."
        label.setLinespace(spacing: 2)
        label.textAlignment = .center
        label.font = .regular(size: 16)
        label.numberOfLines = 0
        label.textColor = .grey1()
        return label
    }()
    
    override init() {
        super.init()
        self.animateSetting.animation.present.damping = 0.7
        self.animateSetting.animation.dismiss.duration = 0
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] in
            TodocInfo.shared.showSecureGuide()
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        self.backgroundView.alpha = 0.0
        self.contentView.snp.updateConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
        
        self.centerImage.snp.updateConstraints {
            $0.size.equalTo(0)
        }
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        self.backgroundView.alpha = 0.5
        self.contentView.snp.updateConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(198)
        }
        
        self.centerImage.snp.updateConstraints {
            $0.size.equalTo(81)
        }
    }
}

extension SecureGuideViewController {
    private func addSubviews() {
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descLabel)
        
        self.view.addSubview(self.centerImage)
    }
    
    private func setLayout() {
        self.backgroundView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(198)
            $0.centerY.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(6)
            $0.right.equalToSuperview().offset(-6)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.centerX.equalToSuperview()
        }
        
        self.descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        self.centerImage.snp.makeConstraints {
            $0.size.equalTo(81)
            $0.centerX.equalTo(self.contentView)
            $0.top.equalTo(self.contentView.snp.top).offset(-40)
        }
    }
}
