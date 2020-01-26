//
//  BaseView.swift
//  Doctor24
//
//  Created by gabriel.jeong on 10/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

class BaseView: UIView {
    // MARK: Properties
    weak var vc: BaseViewController!
    
    // MARK: Initialize
    required init(controlBy viewController: BaseViewController) {
        vc = viewController
        super.init(frame: UIScreen.main.bounds)
        setBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        // Override
    }
    
    func setBind() {
        // Override
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    @objc func pressedBackView(_ gestureRecognizer: UIPanGestureRecognizer){
        vc.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Deinit
    deinit {

    }
}

