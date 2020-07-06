//
//  ScreenCoordinated.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public enum ScreenPresentationStyle {
    case none
    case modal
}
public struct ControllerModel {
    public let viewController: UIViewController
    public let model: CoordinatedInitiatable
    
}

public protocol ScreenCoordinated {
    var tabItem: UITabBarItem? { get }
    var title: String? { get }
    var tabTitle: String? { get }
    var configuration: ControllerConfiguration { get }
    var controllerModel: ControllerModel { get }
    
    func build<ViewController: ViewControllerModellable,
        ViewModel: CoordinatedInitiatable>(_ controllerType: ViewController.Type,
                                           modelType: ViewModel.Type,
                                           object: Any?) -> ControllerModel
}

public extension ScreenCoordinated {
    
    func build<ViewController: ViewControllerModellable,
        ViewModel: CoordinatedInitiatable>(_ controllerType: ViewController.Type,
                                           modelType: ViewModel.Type,
                                           object: Any? = nil) -> ControllerModel {
        let originalModel = ViewModel(model: object)
        if let model = originalModel as? ViewController.ViewModel {
            let controller = ViewController(model: model)
            if let newController = controller as? UIViewController {
                newController.navigationItem.title = title
                newController.tabBarItem.title = tabTitle
                newController.configuration = configuration
                return ControllerModel(viewController: newController, model: originalModel)
            }
        }
        fatalError("unable to create view controller")
    }
}
