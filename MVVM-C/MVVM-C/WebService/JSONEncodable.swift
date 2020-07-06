//
//  JSONEncodable.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONEncodable {
    var jsonDictionary: JSONDictionary? { get }
    var customJSONDictionary: JSONDictionary? { get }
}

public extension JSONEncodable {
    var jsonDictionary: JSONDictionary? {
        return nil
    }
    var customJSONDictionary: JSONDictionary? {
        return nil
    }
}
