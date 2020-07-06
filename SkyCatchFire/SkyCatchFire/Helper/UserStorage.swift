//
//  UserStorage.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation

struct UserStorage: PersistentStorable {
    
    static let none = "set name of storage"
    
    func getDict<T>(_ type: T.Type, with key: String,
                    usingDecoder decoder: JSONDecoder) -> T? where T: Codable {
        
        let data: Data = getValue(for: key, defaultValue: Data())
        if data.isEmpty {
           return nil
        }
        return try? decoder.decode(type.self, from: data)
    }
    
    func getValue<T>(for key: String, defaultValue: T?) -> T? {
        return (UserDefaults.standard.value(forKey: key) as? T)
    }
    
    func setDict<T>(object: T, forKey key: String,
                    usingEncoder encoder: JSONEncoder) where T: Codable {
        let data = try? encoder.encode(object)
        setValue(key: key, value: data)
    }
    
    func getValue<T>(for key: String, defaultValue: T) -> T {
        return (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue
    }
    
    func setValue<T>(key: String, value: T) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func hasValue(key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) != nil
    }
    
    func resetValues(keys: [String]) {
        for item in keys {
            UserDefaults.standard.removeObject(forKey: item)
        }
    }
}
