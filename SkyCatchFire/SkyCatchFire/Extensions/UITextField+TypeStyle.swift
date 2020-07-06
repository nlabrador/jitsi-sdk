//
//  UITextView+TypeStyle.swift
//  MyChevroletConnect
//
//  Created by Programmer Raymond Barrinuevo on 2/27/20.
//  Copyright © 2020 michael.p.siapno. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

var styleTextFieldAssociatedObject: UInt = 0
var attributeTextFieldAssociatedObject: UInt = 1
extension UITextField: ViewStylable {
    
    var style: AppTypeStyles? {
        get {
            if let associated = objc_getAssociatedObject(self, &styleAssociatedObject) as AnyObject as? AppTypeStyles {
                return associated
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &styleTextFieldAssociatedObject, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.attribute = newValue?.attributes
        }
    }
    
    var attribute: AppTypeStyleAttribute? {
        get {
            let assoc = objc_getAssociatedObject(self, &attributeTextFieldAssociatedObject)
            if assoc == nil {
                return nil
            }
            return assoc as AnyObject as? AppTypeStyleAttribute
        }
        set {
            objc_setAssociatedObject(self, &attributeTextFieldAssociatedObject, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateStyle()
        }
    }
    
    internal func updateStyle() {
        if let styleAttributes = attribute {
            let textStyleAttributes = styleAttributes
            var attribs = textStyleAttributes.attributes()
            if let paragraphAttribs = attribs[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                paragraphAttribs.hyphenationFactor = 1.0
                attribs[NSAttributedString.Key.paragraphStyle] = paragraphAttribs
            }
            if let textColor = textColor {
                attribs[NSAttributedString.Key.foregroundColor] = textColor
            }
            self.defaultTextAttributes = attribs
            layoutIfNeeded()
        }
    }
    
}
