//
//  ReuseIdentifiable.swift
//
//  Created by Raymond Barrinuevo on 06/05/2019.
//  Copyright © 2019 All rights reserved.
//

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { return "\(String(describing: Self.self))ReuseIdentifier" }
}
