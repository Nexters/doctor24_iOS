//
//  TimePickViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TimePickViewController: FadeModalTransitionViewController {
    // MARK: Properties
    private let operatingType: Operating
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
        view.backgroundColor = .white
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let pickerDate: UIDatePicker = {
        let pick = UIDatePicker()
        pick.locale = Locale(identifier: "ko")
        pick.setValue(UIColor.black, forKey: "textColor")
        pick.datePickerMode = .time
        return pick
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(operatingType: Operating) {
        self.operatingType = operatingType
        super.init()
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.confirmButton)
        self.contentView.addSubview(self.pickerDate)
        self.setLayout()
    }
    
    override func setBind() {
        self.confirmButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            switch self.operatingType {
            case .start:
                TodocInfo.shared.startTimeFilter.onNext(self.pickerDate.date)
            case .end:
                TodocInfo.shared.endTimeFilter.onNext(self.pickerDate.date)
            }
            
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
    private func setLayout() {
        self.backgroundView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        self.confirmButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(self.view.bottomSafeAreaInset + 56)
        }
        
        self.pickerDate.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(self.confirmButton.snp.top)
        }
    }
    
    override func onWillPresentView(){
        super.onWillPresentView()
        backgroundView.alpha = 0.0
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
    
    override func onWillDismissView(){
        backgroundView.alpha = 0.4
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(self.view.bottomSafeAreaInset + 254)
        }
    }
    
    override func performCustomPresentationAnimation() {
        super.performCustomPresentationAnimation()
        backgroundView.alpha = 0.4
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(self.view.bottomSafeAreaInset + 254)
        }
    }
    
    override func performCustomDismissingAnimation() {
        backgroundView.alpha = 0.0
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
}

extension TimePickViewController {
    enum Operating {
        case start
        case end
    }
}
