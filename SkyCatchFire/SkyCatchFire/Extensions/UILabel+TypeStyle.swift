//
//  UILabel+TypeStyle.swift
//  MyChevroletConnect
//
//  Created by Programmer Raymond Barrinuevo on 2/27/20.
//  Copyright © 2020 michael.p.siapno. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

var styleAssociatedObject: UInt = 0
var attributeAssociatedObject: UInt = 1

extension UILabel: ViewStylable {
    
    var style: AppTypeStyles? {
        get {
            if let associated = objc_getAssociatedObject(self, &styleAssociatedObject) as? AppTypeStyles {
                return associated
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &styleAssociatedObject, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.attribute = newValue?.attributes
        }
    }
    
    var attribute: AppTypeStyleAttribute? {
        get {
            return objc_getAssociatedObject(self, &attributeAssociatedObject) as? AppTypeStyleAttribute
        }
        set {
            objc_setAssociatedObject(self, &attributeAssociatedObject, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateStyle()
        }
    }
    
    convenience init(style: AppTypeStyles) {
        self.init(attributes: style.attributes)
        self.style = style
    }
    convenience init(attributes: AppTypeStyleAttribute) {
        self.init(frame: CGRect.zero)
        self.attribute = attributes
    }
    
    static func setupSwizzle() {
        swizzleMethod(self, fromMethod: #selector(setter: UILabel.text),
                      toMethod: #selector(UILabel.setStyledText))
    }
    
    @objc func setStyledText(_ text: String) {
        
        // This is not an infinate loop because setStyledText is swizzled to the setter of self.text
        self.setStyledText(text)
        updateStyle()
    }
    
    internal func updateStyle() {
        if let styleAttributes = attribute, let contentText = text {
            attributedText = styleAttributes.createAttributedString(contentText)
            layoutIfNeeded()
        }
    }
}
