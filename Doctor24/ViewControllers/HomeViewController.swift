//
//  ViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    // MARK: Properties
    private var service: Domain.UseCaseProvider?
    private let disposeBag = DisposeBag()

    // MARK: UI Componenet
    private lazy var homeView = HomeView(controlBy: self)
    
    init(service: UseCaseProvider) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView(){
        self.view = self.homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mockAPIButton = UIButton()
        mockAPIButton.backgroundColor = .red

        view.addSubview(mockAPIButton)
        
        mockAPIButton.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        let api = self.service?.makeMockAPIUseCase()
        
        mockAPIButton.rx.tap.flatMapLatest{
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
