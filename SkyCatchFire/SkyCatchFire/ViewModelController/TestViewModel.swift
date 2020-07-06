//
//  TestViewModel.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © JaMaYkAn 2020. All rights reserved.
//

import RxSwift
import MVVM_C

final class TestViewModel: CoordinatedInitiatable {
    
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    // MARK: - Observable vars
    
    required init(model: Any?) {
        
    }
}
