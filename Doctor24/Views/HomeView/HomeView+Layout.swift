//
//  HomeView+Layout.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/03/07.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import NMapsMap

// MARK: HomeView set Layout Function
extension HomeView {
    func setLayout() {
        self.mapControlView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(self.preview.snp.top).offset(300)
        }
        
        self.operatingView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(self.frame.height - 132 - self.bottomSafeAreaInset)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(396 + bottomSafeAreaInset)
        }
        
        self.cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(self.operatingView.snp.top).offset(-24)
            $0.right.equalTo(-24)
            $0.size.equalTo(58)
        }
        
        self.categoryButton.snp.makeConstraints {
            $0.bottom.equalTo(self.operatingView.snp.top).offset(-24)
            $0.left.equalTo(24)
            $0.size.equalTo(58)
        }
        
        self.medicalSelectView.snp.makeConstraints {
            $0.top.equalTo(self.safeArea.top)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(192)
            $0.height.equalTo(58)
        }
        
        self.retrySearchView.snp.makeConstraints {
            $0.top.equalTo(self.medicalSelectView.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(110)
            $0.height.equalTo(44)
        }
        
        self.preview.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        self.aroundListButton.snp.makeConstraints {
            $0.size.equalTo(58)
            $0.centerY.equalTo(self.medicalSelectView)
            $0.right.equalToSuperview().offset(-24)
        }
        
        self.activeCategory.snp.makeConstraints {
            $0.top.right.equalTo(self.categoryButton)
            $0.size.equalTo(20)
        }
    }

    func addSubViews() {
        self.addSubview(self.mapControlView)
        self.addSubview(self.operatingView)
        self.addSubview(self.cameraButton)
        self.addSubview(self.categoryButton)
        self.addSubview(self.activeCategory)
        self.addSubview(self.medicalSelectView)
        self.addSubview(self.retrySearchView)
        self.addSubview(self.preview)
        self.addSubview(self.aroundListButton)
    }
    
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
    
    @objc
    func onOperatingView(_ gestureRecognizer: UIPanGestureRecognizer) {
        if let state = try? operatingView.viewState.value(), state == .close {
            self.onOperatorBack()
            self.onOperatingView()
        }
    }
    
    @objc
    func dismissOperatingView(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.dismissOperatingView()
    }
    
    @objc
    func onDetailView(_ gestureRecognizer: UIPanGestureRecognizer){
        self.previewFullSignal.accept(())
    }
    
    func onPreview(with facility: Model.Todoc.PreviewFacility) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: facility.latitude, lng: facility.longitude))
        cameraUpdate.animation = .linear
        
        self.mapControlView.mapView.moveCamera(cameraUpdate)
        self.retrySearchView.isHidden = true
        self.preview.setData(facility: facility)
        self.preview.alpha = 1.0
        self.layoutIfNeeded()
        var height: CGFloat = 0
        self.operatingView.isHidden = true
        //total - 24
        if facility.medicalType == .hospital {
            height = 306 + self.preview.titleStack.frame.height + self.bottomSafeAreaInset //317
        } else {
            height = 236 + self.preview.titleStack.frame.height + self.bottomSafeAreaInset //295
        }
        
        self.preview.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        })
    }
    
    func dismissPreview() {
        self.operatingView.isHidden = false
        if !self.selectedMarker.isEmpty {
            self.unselectPins()
        }
        self.preview.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        self.preview.alpha = 0.0
                        self.layoutIfNeeded()
        })
    }
    
    func onOperatorBack() {
        self.addSubview(self.operatingBackGround)
        self.operatingBackGround.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        self.bringSubviewToFront(self.operatingView)
        self.layoutIfNeeded()
    }
    
    func removeOperatorBack() {
        self.operatingBackGround.snp.removeConstraints()
        self.operatingBackGround.removeFromSuperview()
    }
    
    func onOperatingView() {
        self.operatingView.viewState.onNext(.open)
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height - (396 + bottomSafeAreaInset))
        }
        
        self.animateOpertaingView(show: true)
    }
    
    func dismissOperatingView() {
        self.operatingBackGround.alpha = 0.0
        self.removeOperatorBack()
        self.operatingView.viewState.onNext(.close)
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height -  (132 + bottomSafeAreaInset))
        }
        
        self.animateOpertaingView(show: false)
        self.bringSubviewToFront(self.preview)
    }
    
    func animateOpertaingView(show: Bool) {
        var backAlpha: CGFloat = 0.0
        var alpha : CGFloat = 0.0
        let maxFontSize:CGFloat = 1
        let minFontSize:CGFloat = 0.87
        var size:CGFloat = 0.0
        
        let start        = operatingView.startView.startTimeLabel
        let end          = operatingView.endView.endTimeLabel
        let spaincg      = operatingView.spacingLabel
        let pickerView   = operatingView.pickerView
        let background   = operatingView.operatingBackgroundView
        let close        = operatingView.closeButton
        
        if show {
            alpha  = 1.0
            backAlpha = 0.6
            size = minFontSize
        } else {
            alpha  = 0.0
            backAlpha = 0.0
            size = maxFontSize
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        let transform = CGAffineTransform(scaleX: size, y: size)
                        close.isHidden = show ? false:true
                        start.transform = transform
                        end.transform   = transform
                        spaincg.transform = transform
                        
                        pickerView.alpha = alpha
                        background.alpha = alpha
                        close.alpha      = alpha
                        self.operatingBackGround.alpha = backAlpha
                        self.layoutIfNeeded()
        })
    }
    
    func convertHideOperatingView() {
        let start        = operatingView.startView.startTimeLabel
        let end          = operatingView.endView.endTimeLabel
        let spacing      = operatingView.spacingLabel
        let holder       = operatingView.holderView
        let title        = operatingView.titleLabel
        let refresh      = operatingView.refreshButton
        
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height - (56 + bottomSafeAreaInset))
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        start.alpha = 0.0
                        end.alpha = 0.0
                        spacing.alpha = 0.0
                        holder.alpha = 0.0
                        refresh.alpha = 0.0
                        title.textColor = .grey3()
                        self.categoryButton.alpha = 0.0
                        self.layoutIfNeeded()
        })
    }
    
    func revertOperatingView() {
        let start        = operatingView.startView.startTimeLabel
        let end          = operatingView.endView.endTimeLabel
        let spacing      = operatingView.spacingLabel
        let holder       = operatingView.holderView
        let title        = operatingView.titleLabel
        let refresh      = operatingView.refreshButton
        
        self.operatingView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(self.frame.height -  (132 + bottomSafeAreaInset))
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        start.alpha = 1.0
                        end.alpha = 1.0
                        spacing.alpha = 1.0
                        holder.alpha = 1.0
                        refresh.alpha = 1.0
                        title.textColor = .grey1()
                        self.categoryButton.alpha = 1.0
                        self.layoutIfNeeded()
        })
    }
}
