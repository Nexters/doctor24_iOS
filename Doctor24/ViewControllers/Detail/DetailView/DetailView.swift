//
//  DetailView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/06.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import NMapsMap
import RxSwift
import RxCocoa

final class DetailView: BaseView, FacilityTitleable {
    // MARK: Property
    private var phoneNumber: String = ""
    private let disposeBag = DisposeBag()
    var facility: Model.Todoc.DetailFacility? {
        didSet{
            if self.facility?.convertDaysArray().count ?? 0 > 0 {
                var result = [(String,String)?]()
                self.facility?.convertDaysArray().forEach { days in
                    let day = days.map{ $0.dayType?.convert() ?? "" }.joined(separator: ", ")
                    let time = days.map { "\($0.startTime.convertTotal) ~ \($0.endTime.convertTotal)" }.first
                    result.append((day, time ?? ""))
                }
                
                if result.count % 2 != 0 {
                    result.append(nil)
                }
                
                self.detailData.append(.day(result))
            }
            
            if let phone = self.facility?.phone {
                self.detailData.append(.phone(phone))
            }
            
            if let address = self.facility?.address {
                self.detailData.append(.distance((self.distance(lat: self.facility?.latitude ?? 0.0, long: self.facility?.longitude ?? 0.0), address)))
            }
            
            if let category = self.category(with: self.facility!) {
                self.detailData.append(.hospitalType(category))
            }
            
            self.topBar.titleLabel.text = self.facility?.name ?? ""
            self.collectionView.reloadData()
            
            if let number = facility?.phone {
                self.phoneNumber = number
                self.callButton.isEnabled = true
                self.callButton.backgroundColor = .blue()
            } else {
                self.callButton.isEnabled = false
                self.callButton.backgroundColor = .grey3()
            }
        }
    }
    
    private var detailData = [DetailCellType]()
    
    // MARK: UI Componenet
    let topBar: TopBar = TopBar()    
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("전화하기", for: .normal)
        button.setTitleColor(.white(), for: .normal)
        button.setTitle("전화번호 정보가 없습니다.", for: .disabled)
        button.setTitleColor(.grey2(), for: .disabled)
        button.backgroundColor = .blue()
        button.titleLabel?.font = .bold(size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: self.frame.width, height: 50)
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        flowLayout.minimumLineSpacing = 6
        flowLayout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate   = self
        cv.backgroundColor = .white
        return cv
    }()
    
        
    override func setupUI() {
        self.addSubviews()
        self.setLayout()
        self.registerCell()
    }
    
    override func setBind() {
        self.callButton.rx.tap.subscribe(onNext: {
            TodocEvents.Detail.call.commit()
                guard let url = URL(string: "tel://\(self.phoneNumber.onlyDigits())"),
                    UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
        }).disposed(by: self.disposeBag)
    }
}

// MARK: Private
extension DetailView {
    private func registerCell() {
        self.collectionView.register(DetailLineHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailLineHeader")
        self.collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeaderView")
        self.collectionView.register(DetailNormalCell.self, forCellWithReuseIdentifier: "DetailNormalCell")
        self.collectionView.register(DetailDayCell.self, forCellWithReuseIdentifier: "DetailDayCell")
        self.collectionView.register(DetailDistanceCell.self, forCellWithReuseIdentifier: "DetailDistanceCell")
        self.collectionView.register(DetailDayEvenCell.self, forCellWithReuseIdentifier: "DetailDayEvenCell")
    }
    
    private func addSubviews() {
        self.addSubview(self.topBar)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.collectionView)
        self.contentView.addSubview(self.callButton)
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
        
        self.contentView.snp.makeConstraints {
            $0.top.equalTo(self.topBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(self.callButton.snp.top).offset(-8)
        }
        
        self.callButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.safeArea.bottom).offset(-16)
        }
    }
}

extension DetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section > 0 {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailLineHeader", for: indexPath) as! DetailLineHeader
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeaderView", for: indexPath) as! DetailHeaderView
        if let data = self.facility {
            header.setData(data: data)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch detailData[section] {
        case .day(let result):
            return result.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.detailData[indexPath.section] {
        case .hospitalType(let title):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailNormalCell", for: indexPath) as! DetailNormalCell
            cell.setData(type: .hospitalType(title))
            return cell
            
        case .day(let days):
            if indexPath.row % 2 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailDayCell", for: indexPath) as! DetailDayCell
                cell.setData(day: days[indexPath.row]?.day, time: days[indexPath.row]?.time)
                if indexPath.row > 0 {
                    cell.imageView.isHidden = true
                }
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailDayEvenCell", for: indexPath) as! DetailDayEvenCell
                cell.setData(day: days[indexPath.row]?.day, time: days[indexPath.row]?.time)
                
                return cell
            }
            
        case .phone(let phone):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailNormalCell", for: indexPath) as! DetailNormalCell
            cell.setData(type: .phone(phone))
            return cell
            
        case .distance((let distance, let address)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailDistanceCell", for: indexPath) as! DetailDistanceCell
            cell.setData(distance: distance, address: address)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.detailData.count
    }
}

extension DetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.detailData[indexPath.section] {
        case .hospitalType(let title):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailNormalCell", for: indexPath) as! DetailNormalCell
            cell.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
            cell.setData(type: .hospitalType(title))
            cell.layoutIfNeeded()
            
            return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        case .phone:
            return CGSize(width: collectionView.frame.width, height: 18)
        case .day:
            return CGSize(width: (collectionView.frame.width / 2) , height: 40)
            
        case .distance((let distance, let address)):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailDistanceCell", for: indexPath) as! DetailDistanceCell
            cell.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
            cell.setData(distance: distance, address: address)
            cell.layoutIfNeeded()
            
            return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section == 0  else { return CGSize(width: collectionView.frame.width, height: 1) }
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension DetailView {
    enum DetailCellType {
        case hospitalType(String)
        case day([(day: String,time: String)?])
        case phone(String?)
        case distance((distance: String, address: String))
    }
}
