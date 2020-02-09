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
    private let facilities: [Model.Todoc.PreviewFacility]
    let tapFacility = PublishRelay<Model.Todoc.PreviewFacility>()
    
    // MARK: UI Component
    let topBar: TopBar = {
        let bar = TopBar()
        bar.titleLabel.text = "주변 병원 리스트"
        return bar
    }()
    
    private let tableView: UITableView = {
        let tabView = UITableView()
        tabView.backgroundColor = .white
        tabView.rowHeight = UITableView.automaticDimension
        tabView.estimatedRowHeight = 10
        tabView.separatorStyle = .none
        tabView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
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
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey1()
        label.font = .regular(size: 14)
        label.text = "총 0개"
        return label
    }()
    
    required init(controlBy viewController: BaseViewController,
                  facilities: [Model.Todoc.PreviewFacility]) {
        self.facilities = facilities
        super.init(controlBy: viewController)
        self.registerCell()
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(controlBy viewController: BaseViewController) {
        fatalError("init(controlBy:) has not been implemented")
    }
    
    override func setupUI() {
        self.countLabel.text = "총 \(self.facilities.count)개"
        self.addSubview(self.topBar)
        self.addSubview(self.infoView)
        self.infoView.addSubview(self.countLabel)
        self.infoView.addSubview(self.distance)
        self.addSubview(self.tableView)
        
        self.topBar.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            if haveSafeArea {
                $0.height.equalTo(94)
            } else {
                $0.height.equalTo(78)
            }
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
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.infoView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func setBind() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerCell() {
        self.tableView.register(AroundCell.self, forCellReuseIdentifier: "AroundCell")
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
        let cell : AroundCell = tableView.dequeueReusableCell(withIdentifier: "AroundCell", for: indexPath) as! AroundCell
        cell.setData(facility: facilities[indexPath.row])
        return cell
    }
}
