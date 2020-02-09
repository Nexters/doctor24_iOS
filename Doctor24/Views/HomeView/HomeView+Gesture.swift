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
        let point  = gesture.location(in: self)
        let height = self.frame.height
        let operatingView = (gesture.view as! OperatingHoursSetView)
        
        if gesture.view is OperatingHoursSetView {
            originHeight = 132 + bottomSafeAreaInset
            maxHeight = 396 + bottomSafeAreaInset
        }
        
        let start        = operatingView.startView.startTimeLabel
        let end          = operatingView.endView.endTimeLabel
        let spaincg      = operatingView.spacingLabel
        let pickerView   = operatingView.pickerView
        let background   = operatingView.operatingBackgroundView
        
        if gesture.state == .changed {
            if point.y >= 0 && self.frame.height - point.y <= maxHeight{
                let differ = (height - originHeight) - point.y
                if differ + originHeight > originHeight {
                    gesture.view?.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(self.frame.height - (differ + originHeight))
                    }
                    let transform = CGAffineTransform(scaleX: 1 - (differ / 2000), y: (1 - differ / 2000))
                    start.transform = transform
                    end.transform   = transform
                    spaincg.transform = transform
                    background.alpha = differ / 200
                    pickerView.alpha = differ / 200
                }
            }
        } else if gesture.state == .ended {
            if (point.y - self.frame.height / 2) <= maxHeight / 2 {
                self.onOperatingView()
            } else {
                self.dismissOperatingView()
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
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.0,
                           options: [],
                           animations: {
                            var height: CGFloat = 0.0
                            if point.y <= self.vc.view.frame.height/2 {
                                
                                if !self.selectedMarker.isEmpty {
                                    self.unselectPins()
                                }
                                self.previewFullSignal.accept(())
                            } else {
                                height = contentViewHeight
                            }
                            
                            preview.snp.updateConstraints({ make in
                                make.height.equalTo(height)
                            })
                            
                            self.layoutIfNeeded()
            })
        }
    }
}
