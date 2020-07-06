//
//  SwizzleHelper.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation

public func swizzleMethod(_ anyClass: AnyClass, fromMethod selector1: Selector, toMethod selector2: Selector) {
    if let method1: Method = class_getInstanceMethod(anyClass, selector1),
        let method2: Method = class_getInstanceMethod(anyClass, selector2) {
        
        if class_addMethod(anyClass, selector1,
                           method_getImplementation(method2),
                           method_getTypeEncoding(method2)) {
            
            class_replaceMethod(anyClass,
                                selector2,
                                method_getImplementation(method1),
                                method_getTypeEncoding(method1))
        } else {
            method_exchangeImplementations(method1, method2)
        }
    }
}
