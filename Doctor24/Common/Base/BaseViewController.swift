//
//  BaseViewController.swift
//  Doctor24
//
//  Created by gabriel.jeong on 10/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        self.setupUI()
        self.setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self is ClusterListViewController {
            UIApplication.shared.statusBarStyle = .lightContent
        } else if self is AroundViewController {
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            }
        } else if self is DetailViewController {
            if #available(iOS 13.0, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            }
        } else if self is HomeViewController {
            if TodocInfo.shared.theme == .light {
                if #available(iOS 13.0, *) {
                    UIApplication.shared.statusBarStyle = .darkContent
                }
            } else {
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
    }
    
    func setupUI(){
        // override
    }
    
    func setBind() {
        // override
    }
}
