//
//  DetailView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/06.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import NMapsMap

final class DetailView: BaseView {
    // MARK: Property
    
    // MARK: UI Componenet
    private let topBar: TopBar = TopBar()
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        return mapView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("전화하기", for: .normal)
        button.setTitleColor(.white(), for: .normal)
        button.backgroundColor = .blue()
        button.titleLabel?.font = .bold(size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let contentStackView: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .vertical
        return stkView
    }()
    
    override func setupUI() {
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        
    }
}

// MARK: Private
extension DetailView {
    private func addSubviews() {
        self.addSubview(self.topBar)
        self.addSubview(self.mapView)
        self.addSubview(self.contentView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentStackView)
        self.addSubview(self.callButton)
        
//
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        scrollView.addSubview(stackView)
//
//        stackView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//
//        for _ in 1 ..< 100 {
//            let vw = UIButton(type: .system)
//            vw.setTitle("Button", for: [])
//            stackView.addArrangedSubview(vw)
//        }
    }
    
    private func setLayout() {
        self.topBar.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            if haveSafeArea {
                $0.height.equalTo(94)
            } else {
                $0.height.equalTo(78)
            }
        }
        
        self.mapView.snp.makeConstraints {
            $0.top.equalTo(self.topBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240) //x에서 지도 높이 값 물어보기
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.equalTo(self.mapView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.contentView.snp.top)
            $0.bottom.equalTo(self.callButton.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        self.contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.callButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.safeArea.bottom).offset(-16)
        }
    }
}
