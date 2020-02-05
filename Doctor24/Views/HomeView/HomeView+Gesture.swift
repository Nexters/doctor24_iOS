//
//  HomeView+Gesture.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/03.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit
import SnapKit

extension HomeView {
    @objc
    func operatingDragView(_ gesture : UIGestureRecognizer){
        var maxHeight: CGFloat = 0.0
        var originHeight:CGFloat = 0.0
        
        if gesture.view is OperatingHoursSetView {
            originHeight = 132 + bottomSafeAreaInset
            maxHeight = 396 + bottomSafeAreaInset
        }
        
        let point  = gesture.location(in: self)
        let height = self.frame.height
        
        if gesture.state == .changed {
            if point.y >= 0 && self.frame.height - point.y <= maxHeight{
                let differ = (height - originHeight) - point.y
                if differ + originHeight > originHeight {
                    gesture.view?.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(self.frame.height - (differ + originHeight))
                    }
                    
                    (gesture.view as! OperatingHoursSetView).pickerView.alpha = differ / 200
                }
            }
        } else if gesture.state == .ended {
            var height: CGFloat = 0.0
            var alpha : CGFloat = 0.0
            if (point.y - self.frame.height / 2) <= maxHeight / 2 {
                height = maxHeight
                alpha  = 1.0
            } else {
                height = originHeight
                alpha  = 0.0
            }
            
            UIView.animate(withDuration: 0.3) {
                gesture.view?.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(self.frame.height - height)
                }
                
                (gesture.view as! OperatingHoursSetView).pickerView.alpha = alpha
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func previewDragView(_ gesture : UIGestureRecognizer){
        let point  = gesture.location(in: self)
        let height = self.frame.height
        let preview = gesture.view as! PreviewFacilityView
        var contentViewHeight:CGFloat = bottomSafeAreaInset
        if preview.facility.categories?.count ?? 0 > 0 {
            contentViewHeight = 325 + bottomSafeAreaInset
        } else {
            contentViewHeight = 279.0 + bottomSafeAreaInset
        }
        
        if gesture.state == .changed {
            if point.y >= 0 && point.y <= height{
                let differ = (height - contentViewHeight) - point.y
                if differ > 0 {
                    preview.snp.updateConstraints { (make) in
                        make.height.equalTo(differ + contentViewHeight)
                    }
                }
            }
        }else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.3) {
                
                var height: CGFloat = 0.0
                if point.y <= self.vc.view.frame.height/2 {
                    height = self.vc.view.frame.height
                } else {
                    height = contentViewHeight
                }
                
                preview.snp.updateConstraints({ make in
                    make.height.equalTo(height)
                })
                
                self.layoutIfNeeded()
            }
        }
    }
}
