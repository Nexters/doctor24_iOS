//
//  ViewDraggable.swift
//  Doctor24
//
//  Created by gabriel.jeong on 10/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

protocol ViewDraggable where Self: BaseView {
    var contentViewHeight : CGFloat! { get }
    var contentView       : UIView!  { get set }
//    var backgroundView    : UIView?  { get set }
    
    func setupBaseView()
    func onDragContentView(_ gesture : UIGestureRecognizer)
}


extension ViewDraggable{
    func setupBaseView(){
//        self.addSubview(backgroundView)
        self.addSubview(contentView)
//
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(pressedBackView(_:)))
//        gesture.numberOfTapsRequired = 1
//
//        backgroundView.addGestureRecognizer(gesture)
//
//        backgroundView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.left.equalToSuperview()
//            $0.right.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
        
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
                self.contentView.snp.updateConstraints({ [weak self] make in
                    guard let self = self else { return }
                    make.height.equalTo(self.contentViewHeight)
                })
                self.layoutIfNeeded()
            }
        }
    }
}
