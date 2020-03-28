//
//  AroundView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/09.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AroundView: BaseView {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let medicalType: Model.Todoc.MedicalType
    private var facilities: [Model.Todoc.PreviewFacility?]
    let tapFacility = PublishRelay<Model.Todoc.PreviewFacility?>()
    
    // MARK: UI Component
    lazy var topBar: TopBar = {
        let bar = TopBar()
        bar.titleLabel.text = "주변 \(self.medicalTitle()) 리스트"
        return bar
    }()
    
    private let headerLine: UIView = {
        let view = UIView()
        view.backgroundColor = .grey4()
        return view
    }()
    
    private let tableView: UITableView = {
        let tabView = UITableView()
        tabView.backgroundColor = .white
        tabView.rowHeight = UITableView.automaticDimension
        tabView.estimatedRowHeight = 10
        tabView.separatorStyle = .none
        tabView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tabView
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey5()
        return view
    }()
    
    private let distance: UILabel = {
        let label = UILabel()
        label.textColor = .grey1()
        label.font = .regular(size: 14)
        label.text = "거리순"
        return label
    }()
    
    private let distanceEmptyBtn: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey1()
        label.font = .regular(size: 14)
        label.text = "총 0개"
        return label
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white()
        
        let label = UILabel()
        label.text = "\(medicalTitle())을 찾을 수 없습니다."
        
        label.font = .regular(size: 16)
        label.textColor = .grey2()
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.isHidden = true
        
        return view
    }()
    
    required init(controlBy viewController: BaseViewController,
                  facilities: [Model.Todoc.PreviewFacility],
                  type: Model.Todoc.MedicalType) {
        self.facilities = facilities
        self.medicalType = type
        super.init(controlBy: viewController)
        self.registerCell()
        
        if facilities.isEmpty {
            self.countLabel.text = "총 0개"
            self.emptyView.isHidden = false
        } else {
            self.facilities.append(nil)
            self.countLabel.text = "총 \(self.facilities.count - 1)개"
        }
        
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(controlBy viewController: BaseViewController) {
        fatalError("init(controlBy:) has not been implemented")
    }
    
    override func setupUI() {
        
        self.addSubview(self.topBar)
        self.addSubview(self.headerLine)
        self.addSubview(self.infoView)
        self.infoView.addSubview(self.countLabel)
        self.infoView.addSubview(self.distance)
        self.infoView.addSubview(self.distanceEmptyBtn)
        self.addSubview(self.tableView)
        self.addSubview(self.emptyView)
        
        self.topBar.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            if haveSafeArea {
                $0.height.equalTo(94)
            } else {
                $0.height.equalTo(78)
            }
        }
        
        self.headerLine.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(self.infoView.snp.top)
        }
        
        self.infoView.snp.makeConstraints {
            $0.top.equalTo(self.topBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        self.countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        self.distance.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.distanceEmptyBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(self.distance)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.infoView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints {
            $0.top.equalTo(self.infoView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func setBind() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.distanceEmptyBtn.rx.tap.subscribe(onNext: {
            TodocEvents.Around.sortClick.commit()
        }).disposed(by: self.disposeBag)
    }
    
    private func registerCell() {
        self.tableView.register(AroundNoMoreCell.self, forCellReuseIdentifier: "AroundNoMoreCell")
        self.tableView.register(AroundCell.self, forCellReuseIdentifier: "AroundCell")
    }
    
    private func medicalTitle() -> String {
        switch self.medicalType {
        case .hospital:
            return "병원"
        case .pharmacy:
            return "약국"
        case .animal:
            return ""
        }
    }
}

extension AroundView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapFacility.accept(self.facilities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AroundView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let facility = facilities[indexPath.row] {
            let cell : AroundCell = tableView.dequeueReusableCell(withIdentifier: "AroundCell", for: indexPath) as! AroundCell
            cell.selectionStyle = .none
            cell.setData(facility: facility)
            return cell
        } else {
            let cell : AroundNoMoreCell = tableView.dequeueReusableCell(withIdentifier: "AroundNoMoreCell", for: indexPath) as! AroundNoMoreCell
            cell.selectionStyle = .none
            cell.contentLabel.text = "더 이상 \(self.medicalTitle())이 없습니다."
            
            return cell
        }
    }
}
