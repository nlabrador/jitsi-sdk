//
//  PersistentStorable.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation

protocol PersistentStorable {
    func getValue<T>(`for` key: String, defaultValue: T) -> T
    func setValue<T>(key: String, value: T)
    func hasValue(key: String) -> Bool
    
    func getDict<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder) -> T?
    func setDict<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder)
    
    func getValue<T>(`for` key: String, defaultValue: T?) -> T?
}
