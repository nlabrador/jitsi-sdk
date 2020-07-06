//
//  Themable.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

protocol Themable {
    var identifier: String { get }
    var base1: UIColor { get }
    var base2: UIColor { get }
    var base3: UIColor { get }
}

func == (lhs: Themable, rhs: Themable) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    return lhs.identifier == rhs.identifier
}
