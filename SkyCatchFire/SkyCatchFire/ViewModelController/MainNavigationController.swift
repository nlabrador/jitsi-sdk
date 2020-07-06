//
//  MainNavigationController.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © 2020 HIreplicity. All rights reserved.
//

import UIKit
import MVVM_C

final class MainNavigationController: UINavigationController {
    
    fileprivate var lastNavigationHiddenState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .black
        navigationBar.barTintColor = .clear
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = true
        navigationBar.isOpaque = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationBar.prefersLargeTitles = false
        delegate = self
        interactivePopGestureRecognizer?.delegate = nil
        interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = configuration.hideBottomBarWhenPushed
        switch viewController.configuration.leftButton {
        case .empty:
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = nil
        default:
            viewController.navigationItem.hidesBackButton = false
        }
        
        setUpNavigationItems(navigationController: navigationController, viewController: viewController)
        viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
        
        // handle edge swipes
        if let coordinator = topViewController?.transitionCoordinator {
            
            coordinator.notifyWhenInteractionChanges({ context in
                if !context.isCancelled {
                    if let controller = viewController as? ControllerModellable {
                        controller.coordinatedModel.coordinateDelegate?
                            .navigateBack(removeTopController: false)
                        viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
                    }
                }
            })
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        lastNavigationHiddenState = navigationController.isNavigationBarHidden
        viewController.navigationController?.isNavigationBarHidden = viewController.configuration.isNavHidden
    }
}

extension MainNavigationController {
    
    fileprivate func setUpNavigationItems(navigationController: UINavigationController, viewController: UIViewController) {
        if let controller = viewController as? ControllerModellable {
            switch viewController.configuration.leftButton {
            case .back:
                print("Back Button")
            case .none:
                viewController.navigationItem.leftBarButtonItem = nil
            case .customBack:
                print("Set Custom Back")
            default:
                print("None")
            }
            
        }
        
    }
    
}
