//
//  DetailCell.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/07.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import NMapsMap
import RxSwift
import RxCocoa

final class DetailHeaderView: UICollectionReusableView, FacilityTitleable, PinDrawable, MapSelectable, Badgeable {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    private var disposeBag = DisposeBag()
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        if TodocInfo.shared.theme == .night {
            mapView.mapType = .navi
            mapView.isNightModeEnabled = true
        }
        return mapView
    }()
    
    private let blockView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis      = .vertical
        stack.alignment = .leading
        stack.spacing   = 8
        return stack
    }()
    
    private let typeStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis = .horizontal
        stkView.spacing = 6
        return stkView
    }()
    
    var emergency: UIImageView = UIImageView(image: UIImage(named: "emergencyType"))
    var night: UIImageView = UIImageView(image: UIImage(named: "nightType"))
    var normal: UIImageView = UIImageView(image: UIImage(named: "nomal"))
    
    private let hospitalTitle: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textColor = .black()
        label.numberOfLines = 2
        return label
    }()
    
    private let dateStack: UIStackView = {
        let stkView = UIStackView()
        stkView.axis      = .horizontal
        stkView.alignment = .leading
        stkView.spacing   = 8
        return stkView
    }()
    
    private let todayLabel: UILabel = {
        let label  = UILabel()
        label.text = "오늘"
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "오전 9:00 ~ 오후 7:00"
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let navigationButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "navigation"), for: .normal)
        return btn
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setData(data: Model.Todoc.DetailFacility) {
        self.navigationButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectMap(latitude: data.latitude, longitude: data.longitude, title: data.name)
        }).disposed(by: self.disposeBag)
        
        self.hospitalTitle.text = data.name
        self.timeLabel.text  = "\(data.today.startTime.convertDate) ~ \(data.today.endTime.convertDate)"
        self.focusPin(data: data)
        
        self.titleStackView.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(self.navigationButton.snp.left).offset(24)
            $0.bottom.equalTo(self.lineView.snp.top).offset(-16)
            if data.medicalType == .hospital{
                $0.top.equalTo(self.typeStack.snp.bottom).offset(8)
            } else {
                $0.top.equalTo(self.mapView.snp.bottom).offset(27)
            }
        }
        
        guard data.medicalType == .hospital
        else { return }
        
        self.showBadge(night: data.nightTimeServe,
                       emergency: data.emergency)
    }
    
    private func setupUI(){
        self.normal.isHidden = true
        self.emergency.isHidden = true
        self.night.isHidden = true
            
        self.addSubview(self.mapView)
        self.addSubview(self.blockView)
        self.addSubview(self.typeStack)
        self.addSubview(self.titleStackView)
        self.addSubview(self.navigationButton)
        self.addSubview(self.lineView)
        
        self.typeStack.addArrangedSubview(self.normal)
        self.typeStack.addArrangedSubview(self.emergency)
        self.typeStack.addArrangedSubview(self.night)
        self.titleStackView.addArrangedSubview(self.hospitalTitle)
        self.titleStackView.addArrangedSubview(self.dateStack)
        self.dateStack.addArrangedSubview(self.todayLabel)
        self.dateStack.addArrangedSubview(self.timeLabel)
        
        self.mapView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(240)
        }
        
        self.blockView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(self.mapView)
        }
        
        self.navigationButton.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.centerY.equalTo(self.hospitalTitle)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.typeStack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(self.mapView.snp.bottom).offset(24)
        }
        
        self.titleStackView.snp.makeConstraints {
            $0.top.equalTo(self.typeStack.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(self.navigationButton.snp.left).offset(24)
            $0.bottom.equalTo(self.lineView.snp.top).offset(-16)
        }
        
        self.lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
    }
    
    private func focusPin(data: Model.Todoc.DetailFacility) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: data.latitude, lng: data.longitude)
        marker.iconImage = self.detailPin(name: data.name,
                                          medicalType: data.medicalType,
                                          night: data.nightTimeServe,
                                          emergency: data.emergency)
        marker.mapView = self.mapView
        marker.anchor = CGPoint(x: 0.5,y: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
            self.mapView.moveCamera(cameraUpdate)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DetailLineHeader: UICollectionReusableView {
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(1)
        }
    }
}

protocol DetailCellData where Self: UICollectionViewCell {
    func setData(type: DetailView.DetailCellType)
}

final class DetailNormalCell: UICollectionViewCell, DetailCellData, FacilityTitleable {
    private let imageView = UIImageView()
    let content: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(type: DetailView.DetailCellType) {
        switch type {
        case .hospitalType(let title):
            self.imageView.image = UIImage(named: "hospitalType")
            self.content.text = title
            self.imageView.snp.remakeConstraints {
                $0.size.equalTo(24)
                $0.left.equalTo(24)
                $0.top.equalToSuperview()
            }
            
            self.content.snp.remakeConstraints {
                $0.top.equalTo(self.imageView.snp.top).offset(3)
                $0.left.equalTo(self.imageView.snp.right).offset(6)
                $0.right.lessThanOrEqualTo(-24)
                $0.bottom.equalToSuperview()
            }
            
        case .phone(let number):
            self.imageView.image = UIImage(named: "phoneNumber")
            self.content.text = number
            
            self.imageView.snp.remakeConstraints {
                $0.size.equalTo(24)
                $0.left.equalTo(24)
                $0.centerY.equalToSuperview()
            }
            
            self.content.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalTo(self.imageView.snp.right).offset(6)
                $0.right.lessThanOrEqualTo(-24)
                $0.bottom.equalToSuperview()
            }
        default:
            break
        }
    }
    
    private func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.content)
    }
}

final class DetailDayCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "time")
        return imgView
    }()
    
    private let dayTitle: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(day: String?, time: String?) {
        if let day = day, let time = time {
            self.imageView.isHidden = false
            self.dayTitle.isHidden = false
            self.timeLabel.isHidden = false
            
            self.dayTitle.text = day
            self.timeLabel.text = time
            
            switch day {
            case "토요일":
                self.dayTitle.textColor = .blue()
            case "일요일","공휴일":
                self.dayTitle.textColor = .red()
            default:
                self.dayTitle.textColor = .black()
            }
        } else {
            self.imageView.isHidden = true
            self.dayTitle.isHidden = true
            self.timeLabel.isHidden = true
        }
    }
    
    private func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.dayTitle)
        self.addSubview(self.timeLabel)
        
        self.imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.size.equalTo(24)
        }
        
        self.dayTitle.snp.makeConstraints {
            $0.centerY.equalTo(self.imageView)
            $0.left.equalTo(self.imageView.snp.right).offset(6)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.dayTitle.snp.bottom).offset(4)
            $0.left.equalTo(self.dayTitle.snp.left)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

final class DetailDayEvenCell: UICollectionViewCell {
    private let dayTitle: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(day: String?, time: String?) {
        if let day = day, let time = time {
            self.dayTitle.isHidden = false
            self.timeLabel.isHidden = false
            
            self.dayTitle.text = day
            self.timeLabel.text = time
            
            switch day {
            case "토요일":
                self.dayTitle.textColor = .blue()
            case "일요일","공휴일":
                self.dayTitle.textColor = .red()
            default:
                self.dayTitle.textColor = .black()
            }
        } else {
            self.dayTitle.isHidden = true
            self.timeLabel.isHidden = true
        }
    }
    
    private func setupUI() {
        self.addSubview(self.dayTitle)
        self.addSubview(self.timeLabel)
        
        self.dayTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.left.equalToSuperview().offset(31)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.dayTitle.snp.bottom).offset(4)
            $0.left.equalTo(self.dayTitle.snp.left)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

final class DetailDistanceCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "address")
        return imgView
    }()
    
    let distance: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 16)
        label.textColor = .black()
        return label
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .black()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(distance: String, address: String) {
        self.distance.text = distance
        self.address.text  = address
    }
    
    private func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.distance)
        self.addSubview(self.address)
        
        self.imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(24)
            $0.size.equalTo(24)
        }
        
        self.distance.snp.makeConstraints {
            $0.centerY.equalTo(self.imageView)
            $0.left.equalTo(self.imageView.snp.right).offset(6)
        }
        
        self.address.snp.makeConstraints {
            $0.left.equalTo(self.distance)
            $0.right.lessThanOrEqualTo(-24)
            $0.top.equalTo(self.distance.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}
