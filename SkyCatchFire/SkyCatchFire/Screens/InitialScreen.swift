//
//  InitialScreen.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © 2020 HIreplicity. All rights reserved.
//

import Foundation
import UIKit
import MVVM_C

enum InitialScreen: ScreenCoordinated {

    case splash
    case test
    
    var tabItem: UITabBarItem? {
        return nil
    }
    
    var title: String? {
        return ""
    }
    
    var tabTitle: String? {
        return nil
    }
    
    var configuration: ControllerConfiguration {
        return ControllerConfiguration()
    }
    
    var controllerModel: ControllerModel {
        switch self {
        case .test:
            return build(TestViewController.self, modelType: TestViewModel.self)
        case .splash:
            return build(SplashViewController.self, modelType: SplashViewModel.self)
        }
    }
}
