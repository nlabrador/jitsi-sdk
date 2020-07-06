//
//  ViewControllerModellable.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerModellable: class {
    associatedtype ViewModel
    init(model: ViewModel)
}

public protocol ControllerModellable {
    var coordinatedModel: CoordinatedInitiatable { get }
}
