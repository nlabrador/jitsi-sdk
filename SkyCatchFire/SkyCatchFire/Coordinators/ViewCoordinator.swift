//
//  ViewCoordinator.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © 2020 HIreplicity. All rights reserved.
//

import MVVM_C
import Foundation
import UIKit

final class ViewCoordinator: ChildCoordinator {
    public var controller: UIViewController?
    public var navController: UINavigationController?
    public var coordinators: [ViewCoordinator] = []
    var viewModel: CoordinatedInitiatable?
    public init(navController: UINavigationController?, controller: UIViewController) {
        self.controller = controller
        self.navController = navController
        coordinators.append(self)
        if let screenCoordinatable = controller as? ControllerModellable {
            screenCoordinatable.coordinatedModel.coordinateDelegate = self
        }
    }
    public convenience init<NavigationController: UINavigationController>(screen: ScreenCoordinated,
                                                                          navController: NavigationController) {
        let screenModelController = screen.controllerModel
        let screenController = screenModelController.viewController
        self.init(navController: NavigationController(), controller: screenController)
        self.viewModel = screenModelController.model
        self.navController?.tabBarItem = screen.tabItem
    }
    public convenience init<NavigationController: UINavigationController>(singleScreen: ScreenCoordinated,
                                                                          navController: NavigationController) {
        let screenModelController = singleScreen.controllerModel
        let screenController = screenModelController.viewController
        let navController = NavigationController(rootViewController: screenController)
        self.init(navController: navController, controller: screenController)
        self.viewModel = screenModelController.model
    }
    convenience init(screen: ScreenCoordinated) {
        self.init(screen: screen, navController: MainNavigationController())
    }
    
    convenience init(singleScreen: ScreenCoordinated) {
        self.init(singleScreen: singleScreen, navController: MainNavigationController())
    }
}

extension ViewCoordinator: CoordinatorDelegate {
    
    func navigateBack(removeTopController: Bool) {
        if let navigationController = self.navController {
            _ = self.coordinators.popLast()
            if removeTopController {
                navigationController.popViewController(animated: true)
            }
            return
        }
        fatalError("Unable to proceed...")
    }
    @discardableResult
    func coordinate(to screen: ScreenCoordinated) -> CoordinatedInitiatable? {
        let screenModel = screen.controllerModel
        let screenCoordinator = ViewCoordinator(navController: self.navController,
                                                controller: screenModel.viewController)
        
        guard let screen = screenCoordinator.controller else {
            fatalError("Unable to create screen")
        }
        
        if let navigationController = self.navController {
            
            if let presented = navigationController.presentedViewController {
                presented.dismiss(animated: true, completion: nil)
            }
            
            addCoordinator(screenCoordinator)
            navigationController.pushViewController(screen, animated: false)
            return screenModel.model
        }
        fatalError("Unable to proceed..public .")
    }
    
    func navigateToRoot(animated: Bool, screen: ScreenCoordinated?) {
        if let navigationController = self.navController {
            if navigationController.viewControllers.count == 1 {
                return
            }
            if let rootCoordinator = self.coordinators.first {
                self.coordinators.removeAll()
                self.coordinators.append(rootCoordinator)
            }
            navigationController.popToRootViewController(animated: animated)
            if let screen = screen {
                coordinate(to: screen)
            }
            return
        }
    }
    
    func set(screens: [ScreenCoordinated]) {
        
        if let navigationController = self.navController {
            
            if let presented = navigationController.presentedViewController {
                presented.dismiss(animated: true, completion: nil)
            }
            let screenControllers: [UIViewController] = screens.compactMap { screen in
                let screenCoordinator = ViewCoordinator(navController: navigationController,
                                                        controller: screen.controllerModel.viewController)
                addCoordinator(screenCoordinator)
                return screenCoordinator.controller
            }
            
            navigationController.setViewControllers(screenControllers, animated: false)
        }
    }
    
    fileprivate func addCoordinator(_ viewCoordinator: ViewCoordinator) {
        if let coordinatorController = viewCoordinator.controller as? ControllerModellable {
            coordinatorController.coordinatedModel.coordinateDelegate = self
        }
        self.coordinators.append(viewCoordinator)
    }
    
    func dismissPresented() {
        if let presented = controller?.presentedViewController {
            presented.dismiss(animated: true, completion: nil)
        } else if let navPresented = navController?.presentedViewController {
            navPresented.dismiss(animated: true, completion: nil)
        } else if let tabPresented = navController?.tabBarController?.presentedViewController {
            tabPresented.dismiss(animated: true, completion: nil)
        } else {
            navController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow,
            let menuController = window.rootViewController as? UINavigationController else {
                return nil
        }
        return activeTopController(menuController: menuController)
    }
    
    public func activeTopController(menuController: UINavigationController) -> UIViewController {
        if let topController = menuController.topViewController {
            return topController
        }
        fatalError("Unable to find top controller")
    }
    
}
