//
//  AppTheme.swift
//
//  Created by Raymond Barrinuevo on 29/05/2019.
//  Copyright © 2019 All rights reserved.
//

import UIKit

enum AppTheme: String, Themable {

    case none
    
    var identifier: String {
        return rawValue
    }
    
    var base1: UIColor {
        return AppColors.clear
    }
    
    var base2: UIColor {
        return AppColors.white
    }

    var base3: UIColor {
        return AppColors.black
    }
    
}
