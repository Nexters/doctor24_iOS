//
//  ViewController.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/05.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import NMapsMap


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame: view.frame)
        mapView.mapType = .navi
        mapView.isNightModeEnabled = true
        
        view.addSubview(mapView)
    }
}

