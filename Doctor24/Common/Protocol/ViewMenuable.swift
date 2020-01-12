//
//  ViewMenuable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/01/12.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

protocol ViewMenuable {
    var contentViewHeight : CGFloat! { get }
    var contentView       : UIView!  { get set }
    
    func setupBaseView()
}
