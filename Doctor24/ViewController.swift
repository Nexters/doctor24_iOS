//
//  ViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//
import UIKit

import Domain
import NetworkPlatform
import NMapsMap
import SnapKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    private var services: Domain.UseCaseProvider?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame: view.frame)
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        
        let mockAPIButton = UIButton()
        mockAPIButton.backgroundColor = .red
        
        view.addSubview(mockAPIButton)
//        view.addSubview(mapView)
        
        mockAPIButton.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        self.services = NetworkPlatform.UseCaseProvider()
        let api = self.services?.makeMockAPIUseCase()
        
        mockAPIButton.rx.tap.flatMapLatest{ _ in
            api!.mockAPI()
        }.subscribe(onNext:{ result in
            switch result {
            case .success(let books):
                print("result books: \(books)")
            case .failure(let error):
                print("result error: \(error)")
            }
        }).disposed(by: self.disposeBag)
        
    }
}

