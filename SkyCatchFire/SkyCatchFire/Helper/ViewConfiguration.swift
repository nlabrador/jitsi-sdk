//
//  ViewConfiguration.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 2/28/20.
//  Copyright © 2020 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

struct ViewConfigurations {
    
    static func initializeSwizzles() {
        UILabel.setupSwizzle()
        UIButton.setupSwizzle()
    }
}
