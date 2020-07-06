//
//  KeyboardTerminateHelper.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 30/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

protocol KeyboardTerminateHelper {
    var disposeBag: DisposeBag { get }
    func loadTapGuesture()
}

extension KeyboardTerminateHelper where Self: UIViewController {
    
    func loadTapGuesture() {
        
        view.rx.tapGesture().when(.ended).subscribe(onNext: { [weak self] gesture in
            let containerView = gesture.view
            let location = gesture.location(in: containerView)
            let tappedView = containerView?.hitTest(location, with: nil)
            if tappedView is UITextField || tappedView is UITextView {
                return
            }
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
}
