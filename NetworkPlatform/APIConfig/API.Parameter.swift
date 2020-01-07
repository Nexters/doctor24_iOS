//
//  API.Parameter.swift
//  NetworkPlatform
//
//  Created by gabriel.jeong on 07/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation

extension API {
    enum Parameter {
        case map([String: Any?]?)
        case body(Encodable)
    }
}

extension API.Parameter {
    var params: [String : Any] {
        switch self {
        case .map(let dic):
            return dic?.compactMapValues{ $0 } ?? [:]
        case .body(let value):
            return value.toDictionary() ?? [:]
        }
    }
}

extension Encodable {
    fileprivate func toDictionary(keyStrategy strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys, options: JSONSerialization.ReadingOptions = [.allowFragments]) -> [String : Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: options)).flatMap { $0 as? [String:Any] }
    }
}

extension Data {
    func parse<Element: Decodable>(keyStrategy strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> Element {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        return try decoder.decode(Element.self, from: self)
    }
}
