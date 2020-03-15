//
//  CoronaViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

final class CoronaViewController: BaseViewController {
    // MARK: UI Componenet
    private lazy var coronaView = CoronaView(controlBy: self)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView(){
        self.view = self.coronaView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coronaView.setupUI()
        self.coronaView.setBind()
    }
}
