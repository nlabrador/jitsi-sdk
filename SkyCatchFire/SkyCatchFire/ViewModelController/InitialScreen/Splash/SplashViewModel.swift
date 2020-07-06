//
//  SplashViewModel.swift
//  MyChevroletConnect
//
//  Created by Programmer Raymond Barrinuevo on 5/31/20.
//  Copyright © JaMaYkAn 2020. All rights reserved.
//

import RxSwift
import MVVM_C

final class SplashViewModel: CoordinatedInitiatable {
    
    weak var coordinateDelegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    // MARK: - Observable vars
    
    required init(model: Any?) {
        
    }
    
    func splashFinish() {
        let startController = ViewCoordinator(singleScreen: InitialScreen.test).navController
        UIApplication.shared.applicationKeyWindow?.rootViewController = startController
    }
    
}
