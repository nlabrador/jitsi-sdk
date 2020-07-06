//
//  Coordinator.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator {
    func start()
}

public protocol ChildCoordinator: Coordinator {
    var controller: UIViewController? { get }
    var navController: UINavigationController? { get }
    init(navController: UINavigationController?, controller: UIViewController)
}

public extension ChildCoordinator {
    func start() {
        if let navigationController = navController,
            let viewController = controller {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
