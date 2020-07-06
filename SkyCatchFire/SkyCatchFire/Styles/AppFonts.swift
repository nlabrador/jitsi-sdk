//
//  AppFonts.swift
//

import UIKit

enum AppFonts: String {
    case regular = "fontName"

    func size(_ size: CGFloat) -> UIFont {
        let adaptiveSize = UIView.getAdaptiveWidth(size)
        return UIFont(name: rawValue, size: adaptiveSize)!
    }
}
