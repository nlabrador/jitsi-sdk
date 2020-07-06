//
//  AppFontStyle.swift
//

import UIKit

enum AppFontStyle {
    case regular
    
    func size(_ size: CGFloat) -> UIFont {
        switch self {
        case .regular:
            return AppFonts.regular.size(size)
        }
    }
}
