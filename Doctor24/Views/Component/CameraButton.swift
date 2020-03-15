//
//  CameraButton.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import NMapsMap

final class CameraButton: UIButton {
    let cameraType = BehaviorSubject<NMFMyPositionMode>(value: .direction)
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white()
        self.setShadow(radius: 30,
                         shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                         shadowOffset: CGSize(width: 0, height: 2),
                         shadowBlur: 6)
        self.setBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBind() {
        self.cameraType
        .subscribe(onNext: { [weak self] type in
            switch type {
            case .normal:
                self?.setImage(UIImage(named: "cameraOff"), for: .normal)
            case .direction:
                self?.setImage(UIImage(named: "camera2"), for: .normal)
            case .compass:
                self?.setImage(UIImage(named: "camera3"), for: .normal)
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        
        self.rx.tap
            .withLatestFrom(self.cameraType)
            .map { type -> NMFMyPositionMode in
                switch type {
                case .normal:
                    return .direction
                case .direction:
                    return .compass
                case .compass:
                    return .normal
                default:
                    return .normal
                }}
            .bind(to: self.cameraType)
            .disposed(by: self.disposeBag)
    }
}
