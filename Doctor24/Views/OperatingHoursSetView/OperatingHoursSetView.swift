//
//  OperatingHoursSetView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/24.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit
import Toast_Swift
import RxSwift
import RxCocoa

final class OperatingHoursSetView: BaseView {
    
    // MARK: Properties
    let viewState = BehaviorSubject<FilterViewState>(value: .close)
    let pickerConfirm = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let focusButton = BehaviorSubject<FocusTimeButton>(value: .start)
    private let changedTime = PublishRelay<(Date, FocusTimeButton)>()
    private var startTime   = Date()
    private var endTime     = Date().addingTimeInterval(TimeInterval(30.0*60.0))
    // MARK: UI Componenet
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    let pickerView: PickerView = {
        let view = PickerView()
        view.backgroundColor = .white()
        view.alpha = 0.0
        view.confirmButton(able: false)
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grey3()
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "진료시간"
        label.font = .bold(size: 14)
        label.textColor = .grey1()
        return label
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.titleLabel?.font = .medium(size: 14)
        button.setTitleColor(.blue(), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let operatingStackView: UIStackView = {
        let stkView = UIStackView()
        stkView.spacing = 22
        stkView.axis = .horizontal
        stkView.alignment = .center
        return stkView
    }()
    
    let operatingBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        view.layer.cornerRadius = 8
        view.alpha = 0
        return view
    }()
    
    let startView: StartView = {
        let view = StartView()
        view.able(true)
        return view
    }()
    
    let endView: EndView = {
        let view = EndView()
        view.able(false)
        return view
    }()
    
    let spacingLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .bold(size: 22)
        label.textColor = .black()
        return label
    }()
    
    required init(controlBy viewController: BaseViewController) {
        super.init(controlBy: viewController)
        TodocInfo.shared.startTimeFilter.onNext(self.startTime)
        TodocInfo.shared.endTimeFilter.onNext(self.endTime)
        self.setupUI()
        self.setBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.backgroundColor = .clear
        self.addSubviews()
        self.setLayout()
    }
    
    override func setBind() {
        self.registerNoti()
        
        self.refreshButton.rx.tap.subscribe(onNext: {
            self.refreshButton.isHidden = true
            let start = Date()
            let end   = Date().addingTimeInterval(TimeInterval(30.0*60.0))
            TodocInfo.shared.startTimeFilter.onNext(start)
            TodocInfo.shared.endTimeFilter.onNext(end)
            self.startView.startTimeLabel.text = start.convertDate
            self.endView.endTimeLabel.text     = end.convertDate
            self.startTime = start
            self.endTime   = end
        }).disposed(by: self.disposeBag)
        
        self.focusButton.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .start:
                self.pickerView.pickerDate.setDate(self.startTime, animated: true)
            case .end:
                self.pickerView.pickerDate.setDate(self.endTime, animated: true)
                self.maxEndTime()
            }
        }).disposed(by: self.disposeBag)
        
        self.startView.startTimeButton.rx.tap
            .withLatestFrom(self.viewState).filter { $0 == .open }
            .do(onNext: { [weak self] _ in
                self?.startView.able(true)
                self?.endView.able(false)
            })
            .map { _ in FocusTimeButton.start }
            .bind(to: self.focusButton)
            .disposed(by: self.disposeBag)
        
        self.endView.endTimeButton.rx.tap
            .withLatestFrom(self.viewState).filter { $0 == .open }
            .do(onNext: { [weak self] _ in
                self?.startView.able(false)
                self?.endView.able(true)
            })
            .map { _ in FocusTimeButton.end }
            .bind(to: self.focusButton)
            .disposed(by: self.disposeBag)
        
        self.pickerView.confirmButton.rx.tap
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.startTime.ampm == "오후" && self.endTime.ampm == "오전" {
                    self.makeToast("12시 넘어가면 안돼여!!!!")
                    return false
                }

                if self.startTime.compareTimeOnly(to: self.endTime) == .orderedDescending {
                    self.makeToast("안돼여!!")
                    return false
                }
                
                return true
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.refreshButton.isHidden = false
                TodocInfo.shared.startTimeFilter.onNext(self.startTime)
                TodocInfo.shared.endTimeFilter.onNext(self.endTime)
            })
            .bind(to: self.pickerConfirm)
            .disposed(by:self.disposeBag)
        
        self.changedTime.subscribe(onNext: { [weak self] date, type in
            guard let self = self else { return }
            switch type {
            case .start:
                self.startView.startTimeLabel.text = date.convertDate
                self.startTime = date
                break
            case .end:
                self.endView.endTimeLabel.text = date.convertDate
                self.endTime = date
                self.maxEndTime()
                
                break
            }
        }).disposed(by: self.disposeBag)
        
        self.viewState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .open:
                self.closeButton.isHidden = false
                self.startView.able(true)
                self.endView.able(false)
                self.pickerView.confirmButton(able: false)
                self.focusButton.onNext(.start)
            case .close:
                self.closeButton.isHidden = true
                self.startView.able(true)
                self.endView.able(true)
                if let start = try? TodocInfo.shared.startTimeFilter.value(),
                    let end = try? TodocInfo.shared.endTimeFilter.value() {
                    self.startView.startTimeLabel.text = start.convertDate
                    self.endView.endTimeLabel.text     = end.convertDate
                    self.startTime = start
                    self.endTime   = end
                    
                    self.maxEndTime()
                }
            }
        }).disposed(by: self.disposeBag)
    }
}

// MARK: Private
extension OperatingHoursSetView {
    private func addSubviews() {
        self.addSubview(self.contentView)
        self.operatingStackView.addArrangedSubview(self.startView)
        self.operatingStackView.addArrangedSubview(self.spacingLabel)
        self.operatingStackView.addArrangedSubview(self.endView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.refreshButton)
        self.contentView.addSubview(self.operatingBackgroundView)
        self.contentView.addSubview(self.operatingStackView)
        self.contentView.addSubview(self.pickerView)
    }
    
    private func setLayout() {
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel)
            $0.size.equalTo(50)
            $0.left.equalToSuperview().offset(24)
        }
        
        self.lineView.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
        }
        
        self.contentView.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.lineView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        self.refreshButton.snp.makeConstraints {
            $0.centerY.equalTo(self.titleLabel)
            $0.right.equalToSuperview().offset(-24)
            $0.size.equalTo(50)
        }
        
        self.operatingBackgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
        
        self.operatingStackView.snp.makeConstraints{
            $0.center.equalTo(self.operatingBackgroundView)
        }
        
        self.pickerView.snp.makeConstraints {
            $0.top.equalTo(self.operatingBackgroundView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func registerNoti(){
        self.pickerView.pickerDate.addTarget(self, action: #selector(changedDatePikcer), for: .valueChanged)
    }
    
    @objc
    private func changedDatePikcer() {
        self.pickerView.confirmButton(able: true)
        Observable.just(self.pickerView.pickerDate.date)
            .withLatestFrom(self.focusButton) { ($0,$1) }
            .bind(to: self.changedTime)
            .disposed(by: self.disposeBag)
    }
    
    private func maxEndTime() {
        print("jhh self.startTime.ampm: \(self.startTime.ampm)")
        print("jhh self.endTime.ampm: \(self.endTime.ampm)")
        print("jhh Date().endTime(): \(Date().endTime()!)")
        
        if self.startTime.ampm == "오후" && self.endTime.ampm == "오전" {
            self.pickerView.pickerDate.setDate(Date().endTime(), animated: true)
            self.endView.endTimeLabel.text = Date().endTime().convertDate
            self.endTime = Date().endTime()
        }
    }
}

extension OperatingHoursSetView {
    enum FilterViewState {
        case open
        case close
    }
    
    enum FocusTimeButton {
        case start
        case end
    }
}
