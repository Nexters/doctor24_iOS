//
//  MockData.swift
//  Domain
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

extension Model {
    public struct MockData: Codable {
        struct Book : Codable {
            let title     : String
            let subtitle  : String
            let isbn13    : String
            let price     : String
            let image     : String
            let url       : String
        }
        
        struct NewBooks : Codable {
            let total:String
            let books:[Book]
        }
    }
}
