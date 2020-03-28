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
    
    func showBadge(night: Bool, emergency: Bool)
}

extension Badgeable {
    
    func showBadge(night: Bool, emergency: Bool) {
        self.normalBadge(night: night, emergency: emergency)
    }
    
    private func normalBadge(night: Bool, emergency: Bool) {
        self.normal.isHidden = false
        
        switch (night, emergency) {
        case (true, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = false
            
        case (false, true):
            self.normal.isHidden = true
            self.emergency.isHidden = false
            self.night.isHidden = true
            
        case (true, false):
            self.normal.isHidden = true
            self.emergency.isHidden = true
            self.night.isHidden = false
            
        case (false, false):
            self.normal.isHidden = false
            self.emergency.isHidden = true
            self.night.isHidden = true
        }
    }
}

