//
//  ScreenCoordinator.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © 2020 HIreplicity. All rights reserved.
//

import UIKit
import MVVM_C

final class ScreenCoordinator: Coordinator {
    
    fileprivate let window: UIWindow?
    @discardableResult
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let startController = ViewCoordinator(singleScreen: InitialScreen.splash).navController
        self.window?.rootViewController = startController
    }

}
