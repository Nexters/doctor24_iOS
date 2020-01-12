//
//  ViewDraggable.swift
//  Doctor24
//
//  Created by gabriel.jeong on 10/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

protocol ViewDraggable: ViewMenuable where Self: BaseView {
    func onDragContentView(_ gesture : UIGestureRecognizer)
}

extension ViewDraggable{
    func setupBaseView(){
        self.addSubview(contentView)
        self.contentView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(self.contentViewHeight)
        }
    }
    
    func onDragContentView(_ gesture : UIGestureRecognizer){
        let point  = gesture.location(in: self)
        let height = self.frame.height
        
        if gesture.state == .changed {
            print("postion : \(gesture.location(in: self))")
            if point.y >= 0 && point.y <= height{
                let differ = (height - contentViewHeight) - point.y
                if differ > 0 {
                    contentView.snp.updateConstraints { (make) in
                        make.height.equalTo(differ + contentViewHeight)
                        print("\(differ + contentViewHeight)")
                    }
                }
            }
        }else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.3) {
                
                var height: CGFloat = 0.0
                if point.y <= self.vc.view.frame.height/2 {
                    height = self.vc.view.frame.height
                } else {
                    height = self.contentViewHeight
                }
                
                self.contentView.snp.updateConstraints({ make in
                    make.height.equalTo(height)
                })
                
                self.layoutIfNeeded()
            }
        }
    }
}
