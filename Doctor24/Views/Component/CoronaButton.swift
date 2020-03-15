//
//  CoronaButton.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/25.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CoronaButton: UIButton {
    enum ButtonState {
        case focused
        case normal
    }
    
    let buttonState = BehaviorRelay<ButtonState>(value: .normal)
    private let disposeBag = DisposeBag()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.grey2(), for: .normal)
        self.titleLabel?.font = UIFont.regular(size: 14)
        self.setShadow(radius: 16,
                       shadowColor: UIColor(red: 74, green: 74, blue: 74, alpha: 0.14),
                       shadowOffset: CGSize(width: 0, height: 2),
                       shadowBlur: 6)
        self.setBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBind() {
        self.buttonState
            .subscribe(onNext: { type in
                switch type {
                case .focused:
                    self.titleLabel?.font = UIFont.bold(size: 14)
                    self.backgroundColor = .blue()
                    self.setTitleColor(.white(), for: .normal)
                case .normal:
                    self.titleLabel?.font = UIFont.regular(size: 14)
                    self.backgroundColor = .white()
                    self.setTitleColor(.grey2(), for: .normal)
                }
            }).disposed(by: self.disposeBag)
        
        self.rx.tap
            .withLatestFrom(buttonState)
            .map{ _ in
                .focused
            }.bind(to: self.buttonState)
            .disposed(by: self.disposeBag)
    }
}
