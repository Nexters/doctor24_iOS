//
//  LookAroundView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/11.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

final class LookAroundView: BaseView, ViewDraggable {

    // MARK: Properties
    var contentViewHeight: CGFloat! = 61
    
    // MARK: UI Componenet
    lazy var contentView: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragView(_:)))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    lazy var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주변 병원보기"
        label.textColor = .black
        return label
    }()
    
    override func setupUI() {
        self.backgroundColor = .clear
        self.setupBaseView()
        self.addSubViews()
        self.setLayout()
    }
    
    override func setBind() {
        
    }
}

// MARK: Private function
extension LookAroundView {
    private func setLayout() {
        self.contentTitleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    private func addSubViews() {
        self.contentView.addSubview(self.contentTitleLabel)
        self.addSubview(self.contentView)
    }
    
    @objc
    private func dragView(_ gesture : UIGestureRecognizer){
        self.onDragContentView(gesture)
    }
}
