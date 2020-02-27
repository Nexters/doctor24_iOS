//
//  Badgeable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/26.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

protocol Badgeable {
    var emergency: UIImageView { get }
    var night: UIImageView { get }
    var normal: UIImageView { get }
    var corona: UIImageView { get }
    
    func showBadge(night: Bool, emergency: Bool, corona: Bool)
}

extension Badgeable {
    func showBadge(night: Bool, emergency: Bool, corona: Bool) {
        switch (night, emergency, corona) {
        case (true, true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            self.corona.isHidden = false
            
        case (true, true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            self.corona.isHidden = true
            
        case (false, true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = true
            self.corona.isHidden = false
            
        case (false, true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = true
            self.corona.isHidden = true
            
        case (true, false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            self.corona.isHidden = false
            
        case (true, false, false):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            self.corona.isHidden = true
            
        case (false, false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = true
            self.corona.isHidden = false
            
        case (false, false, false):
            self.normal.isHidden = false
            self.emergency.isHidden = true
            self.night.isHidden = true
            self.corona.isHidden = true
        }
    }
}

