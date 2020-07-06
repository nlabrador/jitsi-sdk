//
//  ScreenGroupCoordinated.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public protocol ScreenGroupCoordinated {
    var screens: [ScreenCoordinated] { get }
    var title: String { get }
    var tabItem: UITabBarItem? { get }
    var configuration: ControllerConfiguration { get }
}
