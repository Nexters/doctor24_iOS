//
//  PinDrawable.swift
//  Doctor24
//
//  Created by Haehyeon Jeong on 2020/02/08.
//  Copyright © 2020 JHH. All rights reserved.
//
import Domain

import UIKit
import NMapsMap
import SnapKit

protocol PinDrawable {
    func clusterPin(count: Int) -> NMFOverlayImage
    func detailPin(name: String, medicalType: Model.Todoc.MedicalType) -> NMFOverlayImage
    func pin(facility: Model.Todoc.PreviewFacility) -> NMFOverlayImage
}

extension PinDrawable {
    func pin(facility: Model.Todoc.PreviewFacility) -> NMFOverlayImage {
        switch (facility.emergency, facility.nightTimeServe, facility.medicalType == .pharmacy) {
        case (_, _, true):
            //약국
            return NMFOverlayImage(name: "drugStore")
        case (_, true, false):
            //야간
            return NMFOverlayImage(name: "nightHospital")
        case (true, false, false):
            //응급
            return NMFOverlayImage(name: "emergency")
        default:
            //기본
            return NMFOverlayImage(name: "hospital")
        }
    }
    
    func clusterPin(count: Int) -> NMFOverlayImage {
        let container   = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        let defaultMark = UIImageView(image: UIImage(named: "hospital"))
        let countImg    = UIImageView(image: UIImage(named: "number"))
        let countLabel  = UILabel()
        
        countLabel.textAlignment = .center
        countLabel.text = "\(count)"
        countLabel.textColor = .black()
        countLabel.font = UIFont.bold(size: 10)
        
        container.addSubview(defaultMark)
        container.addSubview(countImg)
        container.addSubview(countLabel)
        
        defaultMark.frame = CGRect(x: 0, y: 32 - 24, width: 24, height: 24)
        countImg.frame    = CGRect(x: 32 - 20, y: 0, width: 20, height: 20)
        countLabel.frame  = CGRect(x: 0, y: 0, width: 12, height: 12)
        countLabel.center = countImg.center
        
        return NMFOverlayImage(image: container.asImage())
    }
    
    func detailPin(name: String, medicalType: Model.Todoc.MedicalType) -> NMFOverlayImage {
        let container     = UIView()
        let detailImg     = medicalType == .hospital ? UIImage(named: "detailHospital") : UIImage(named: "detailDrugStore")
        let detailImgView = UIImageView(image: detailImg)
        let titleLabel    = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 14))
        let titleBack     = UIView()
        
        titleLabel.text = name
        titleLabel.font = UIFont.regular(size: 12)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .grey1()
        
        
        titleBack.backgroundColor    = .white()
        titleBack.layer.cornerRadius = 8
        
        container.frame = CGRect(x: 0, y: 0, width: titleLabel.frame.width + 20, height: 82)
        titleBack.frame = CGRect(x: 0, y: 82 - 22, width: titleLabel.frame.width + 20, height: 22)
        detailImgView.frame = CGRect(x: 0, y: 0, width: 54, height: 54)
        detailImgView.center = CGPoint(x: container.center.x, y: detailImgView.center.y)
        titleLabel.center = titleBack.center
        
        container.addSubview(detailImgView)
        container.addSubview(titleBack)
        container.addSubview(titleLabel)
        
        return NMFOverlayImage(image: container.asImage())
    }
}

