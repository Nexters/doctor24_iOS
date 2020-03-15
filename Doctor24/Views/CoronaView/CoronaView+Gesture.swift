//
//  CoronaView+Gesture.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/15.
//  Copyright © 2020 JHH. All rights reserved.
//

import UIKit

extension CoronaView {
    func addGesture() {
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(triggerTouchAction))
        self.panGestureRecognizer.delegate = self
        self.mapControlView.mapView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    func removeGesture() {
        self.mapControlView.mapView.removeGestureRecognizer(self.panGestureRecognizer)
    }
    
    @objc
    func triggerTouchAction(){
        self.panGestureMap.accept(())
    }
}

extension CoronaView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
