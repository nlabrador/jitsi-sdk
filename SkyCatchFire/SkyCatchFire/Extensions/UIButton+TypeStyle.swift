//
//  UIButton+TypeStyle.swift
//  MyChevroletConnect
//
//  Created by Programmer Raymond Barrinuevo on 2/27/20.
//  Copyright © 2020 michael.p.siapno. All rights reserved.
//

import UIKit

var buttonStyleKey: UInt = 0
var buttonAttributeKey: UInt = 1

enum AttributeKeys: String, Hashable {
    case normal
    case highlighted
    case disabled
    
    var controlState: UIControl.State? {
        switch self {
        case .normal:
            return UIControl.State.normal
        case .highlighted:
            return UIControl.State.highlighted
        case .disabled:
            return UIControl.State.disabled
        }
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension UIButton {
    typealias StyleKeyValues = [AttributeKeys: AppTypeStyles]
    typealias AttributeKeyValues = [AttributeKeys: AppTypeStyleAttribute]
    
    var styles: StyleKeyValues {
        get {
            if let associated = objc_getAssociatedObject(self, &buttonStyleKey) as? StyleKeyValues {
                return associated
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &buttonStyleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            newValue.forEach { key, value in
                attributes[key] = value.attributes
            }
        }
    }
    
    var attributes: AttributeKeyValues {
        get {
            if let associated = objc_getAssociatedObject(self, &buttonAttributeKey) as? AttributeKeyValues {
                return associated
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &buttonAttributeKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyStyle()
        }
    }
    
    static func setupSwizzle() {
        swizzleMethod(self, fromMethod: #selector(UIButton.setTitle(_:for:)),
                      toMethod: #selector(UIButton.setStyledTitle(_:for:)))
    }
    
    @objc func setStyledTitle(_ title: String?, for: UIControl.State) {
        
        // This is not an infinate loop because setStyledTitle is swizzled to setTitle
        setStyledTitle(title, for: `for`)
        applyStyle()
    }
    
//    fileprivate func applyStyle() {
//        attributes.forEach { key, value in
//            if let title = currentTitle,
//                let state = key.controlState {
//                var updatedStyle = value
//                updatedStyle.isScalable = (titleLabel?.adjustsFontForContentSizeCategory ?? false) ? true : false
//                let attribText = updatedStyle.createAttributedString(title)
//                titleLabel?.attributedText = attribText
//                setAttributedTitle(attribText, for: state)
//                // Incase we have a selected state as well we need to specify a highlighted/selected state
//                if state == .highlighted {
//                    setAttributedTitle(value.createAttributedString(title), for: [.highlighted, .selected])
//                }
//            } else {
//                titleLabel?.attributedText = nil
//                setAttributedTitle(titleLabel?.attributedText, for: state)
//            }
//        }
//    }
    
    fileprivate func applyStyle() {
        attributes.forEach { key, value in
            if let title = currentTitle,
                let state = key.controlState {
                let updatedStyle = value
                let attribText = updatedStyle.createAttributedString(title)
                titleLabel?.attributedText = attribText
                setAttributedTitle(attribText, for: state)
                // Incase we have a selected state as well we need to specify a highlighted/selected state
                if state == .highlighted {
                    setAttributedTitle(value.createAttributedString(title), for: [.highlighted, .selected])
                }
            } else {
                titleLabel?.attributedText = nil
                setAttributedTitle(titleLabel?.attributedText, for: state)
            }
        }
    }
    
}
