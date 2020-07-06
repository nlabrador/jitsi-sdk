//
//  UIViewController+Configuration.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public struct ControllerConfiguration {
    
    public struct CustomBack {
        public let title: String
        public let color: UIColor
        
        public init(title: String, color: UIColor) {
            self.title = title
            self.color = color
        }
    }
    
    public enum LeftButtonType {
        case `default`
        case back
        case none
        case empty
        case customBack(CustomBack)
    }
    
    public enum RightButtonType {
        case `default`
        case none
        case custom(barItem: UIBarButtonItem, screen: ScreenCoordinated)
    }
    
    public var leftButton: LeftButtonType = LeftButtonType.default
    public var rightButton: RightButtonType = RightButtonType.none
    public var hideBottomBarWhenPushed: Bool = false
    public var isNavHidden: Bool = false
    
    public init() {
        leftButton = LeftButtonType.none
        rightButton = RightButtonType.none
    }
}

fileprivate var controllerAssocKey: UInt8 = 11

public extension UIViewController {
    
    var configuration: ControllerConfiguration {
        get {
            return (objc_getAssociatedObject(self,
                                             &controllerAssocKey)
                as? ControllerConfiguration) ?? ControllerConfiguration()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &controllerAssocKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
