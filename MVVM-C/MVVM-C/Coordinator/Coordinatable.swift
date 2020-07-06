//
//  Coordinatable.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public typealias CoordinatedInitiatable = Coordinatable & ViewModelIniatable
public protocol Coordinatable: class {
    var coordinateDelegate: CoordinatorDelegate? { get set }
}

public struct ModalConfig {
    public let modalPresentationStyle: UIModalPresentationStyle
    public let modalTransitionStyle: UIModalTransitionStyle
    public let useTopParent: Bool
    
    public init(modalPresentationStyle: UIModalPresentationStyle,
                modalTransitionStyle: UIModalTransitionStyle,
                useTopParent: Bool) {
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.useTopParent = useTopParent
    }
}
public extension ModalConfig {
    init(modalPresentationStyle: UIModalPresentationStyle, modalTransitionStyle: UIModalTransitionStyle) {
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.useTopParent = false
    }
}

public protocol CoordinatorDelegate: class {
    func navigateBack(removeTopController: Bool)
    @discardableResult
    func coordinate(to screen: ScreenCoordinated) -> CoordinatedInitiatable?
    func navigateToRoot(animated: Bool, screen: ScreenCoordinated?)
    func set(screens: [ScreenCoordinated])
    func dismissPresented()
}
