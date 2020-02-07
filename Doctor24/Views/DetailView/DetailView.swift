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

final class DetailView: BaseView, FacilityTitleable {
    // MARK: Property
    var facility: Model.Todoc.DetailFacility? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    // MARK: UI Componenet
    let topBar: TopBar = TopBar()
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
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = CGSize(width: self.frame.width, height: 50)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 11.5, right: 0)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.dataSource = self
        cv.delegate   = self
        return cv
    }()
    
        
    override func setupUI() {
        self.addSubviews()
        self.setLayout()
        self.registerCell()
    }
    
    override func setBind() {
        
    }
}

// MARK: Private
extension DetailView {
    private func registerCell() {
        self.collectionView.register(DetailLineHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailLineHeader")
        self.collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeaderView")
        self.collectionView.register(DetailNormalCell.self, forCellWithReuseIdentifier: "DetailNormalCell")
    }
    
    private func addSubviews() {
        self.addSubview(self.topBar)
        self.addSubview(self.mapView)
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
        
        self.mapView.snp.makeConstraints {
            $0.top.equalTo(self.topBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240) //x에서 지도 높이 값 물어보기
        }
        
        self.contentView.snp.makeConstraints {
            $0.top.equalTo(self.mapView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(self.callButton.snp.top).offset(16)
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = self.facility else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailNormalCell", for: indexPath) as! DetailNormalCell
        
        if indexPath.section == 0 {
            cell.setData(type: .HospitalType(self.category(with: data) ?? ""))
        } else {
            cell.setData(type: .phone(data.phone))
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension DetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 1)
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
        case HospitalType(String)
        case day([(day: String,time: String)])
        case phone(String)
        case distance((distance: String, address: String))
    }
}
