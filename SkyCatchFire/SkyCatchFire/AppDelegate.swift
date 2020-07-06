//
//  AppDelegate.swift
//  SkyCatchFire
//
//  Created by Raymond Barrinuevo on 6/13/20.
//  Copyright © 2020 HIreplicity. All rights reserved.
//

import UIKit
import JitsiMeet

extension UIApplication {
    var applicationKeyWindow: UIWindow? {
        return windows.filter { $0.isKeyWindow }.first
    }
    
    var applicationStatusBarFrame: CGRect {
        if #available(iOS 13.0, *) {
            return applicationKeyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ViewConfigurations.initializeSwizzles()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = ScreenCoordinator(window: window)
        coordinator.start()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return JitsiMeet.sharedInstance().application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return JitsiMeet.sharedInstance().application(app, open: url, options: options)
    }
    
}
