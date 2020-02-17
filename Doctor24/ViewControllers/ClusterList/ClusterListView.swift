//
//  ClusterListView.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/11.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain
import UIKit
import RxSwift
import RxCocoa

final class ClusterListView: BaseView {
    let tapFacility = PublishRelay<Model.Todoc.PreviewFacility>()
    
    private let facilities: [Model.Todoc.PreviewFacility]
    private let tableView: UITableView = {
        let tabView = UITableView()
        tabView.backgroundColor = .white
        tabView.rowHeight = UITableView.automaticDimension
        tabView.estimatedRowHeight = 10
        tabView.separatorStyle = .none
        tabView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tabView
    }()
    
    // MARK: UI Componenet
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white()
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rectangle"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "병원 리스트"
        label.font = .bold(size: 14)
        label.textColor = .grey1()
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
        self.backgroundColor = .clear
        self.addSubViews()
        self.setLayout()
    }
    
    override func setBind() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerCell() {
        self.tableView.register(ClusterCell.self, forCellReuseIdentifier: "ClusterCell")
    }
}

// MARK: Animate View
extension ClusterListView {
    func onWillPresentView(){
        self.backgroundView.alpha = 0.0
        self.contentView.alpha = 0.0
        self.contentView.snp.updateConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
    }
    
    func performCustomPresentationAnimation() {
        self.backgroundView.alpha = 0.4
        self.contentView.alpha = 1
        //105
        self.contentView.snp.updateConstraints {
            $0.width.equalTo(327)
            if facilities.count < 4 {
                $0.height.equalTo((facilities.count * 105) + 53 + 15)
            } else {
                $0.height.equalTo(478 - 23)
            }
        }
    }
}

// MARK: Private function
extension ClusterListView {
    private func addSubViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.closeButton)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.tableView)
    }
    
    private func setLayout() {
        self.backgroundView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
        
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-16)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.closeButton)
            $0.centerX.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16.5)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension ClusterListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapFacility.accept(self.facilities[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ClusterListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ClusterCell = tableView.dequeueReusableCell(withIdentifier: "ClusterCell", for: indexPath) as! ClusterCell
        cell.selectionStyle = .none
        cell.setData(facility: facilities[indexPath.row])
        return cell
    }
}
