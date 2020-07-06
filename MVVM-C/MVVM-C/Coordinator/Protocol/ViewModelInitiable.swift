//
//  ViewModelInitiable.swift
//  MVVM-C
//
//  Created by michael.p.siapno on 14/09/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public protocol ViewModelIniatable: class {
    var disposeBag: DisposeBag { get set }
    init(model: Any?)
    func dispose()
}

public extension ViewModelIniatable {
    func dispose() {
        disposeBag = DisposeBag()
    }
}
