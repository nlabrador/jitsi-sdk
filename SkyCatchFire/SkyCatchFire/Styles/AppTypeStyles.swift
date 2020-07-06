//
//  AppTypeStyles.swift
//
//  Created by Raymond Barrinuevo on 07/05/2019.
//  Copyright © 2019 All rights reserved.
//

import UIKit

protocol ViewStylable {
    var style: AppTypeStyles? { get set }
    var attribute: AppTypeStyleAttribute? { get set }
    
    func updateStyle()
}

enum CapitalizationType {
    case allCaps, byWord, none
}

struct AppTypeStyleAttribute {
    var font: UIFont = AppFontStyle.regular.size(12)
    var lineHeight: CGFloat = 0.0
    var characterSpacing: CGFloat = 0.0 // kerning
    var color: UIColor = AppColorStyle.base1
    var capStyle: CapitalizationType = .none
    var alignment: NSTextAlignment = .natural
    var isUnderlined: Bool = false
    var lineBreakMode: NSLineBreakMode = .byWordWrapping
    
    func createAttributedString(_ string: String) -> NSMutableAttributedString {
        
        let range = NSRange(location: 0, length: string.count)
        var displayString = string
        switch capStyle {
        case .allCaps:
            displayString = string.uppercased()
        case .byWord:
            displayString = string.capitalized
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: displayString)
        attributedString.addAttributes(attributes(), range: range)
        return attributedString
    }
    func attributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let fontSize = font.pointSize
        
        if lineHeight != 0.0 {
            if lineHeight < fontSize {
                paragraphStyle.lineSpacing = lineHeight - fontSize
                paragraphStyle.maximumLineHeight = max(lineHeight - paragraphStyle.lineSpacing, 0.0)
            } else {
                paragraphStyle.lineSpacing = lineHeight - fontSize
            }
        }
        paragraphStyle.alignment = alignment
        var styleDict: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.kern: characterSpacing]
        if isUnderlined {
            styleDict[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return styleDict
    }
}

enum AppTypeStyles {
    
    case none
    
    var attributes: AppTypeStyleAttribute {
        return AppTypeStyleAttribute()
    }
}
