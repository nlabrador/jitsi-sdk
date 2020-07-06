//
//  UIView+PercentageConstraint.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 26/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import UIKit
/*
 Scales the values using the default AI dimensions for smaller screens
 height = 812 (iphone 6)
 width = 375
 */
fileprivate let referenceSize = CGSize(width: 375, height: 812)
extension UIView {
    
    func topAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                   constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.topAnchor.constraint(equalTo: anchor,
                                         constant: adaptiveHeight(constant))
    }
    
    func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.bottomAnchor.constraint(equalTo: anchor,
                                            constant: adaptiveHeight(constant))
    }
    
    func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                       constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.leadingAnchor.constraint(equalTo: anchor,
                                             constant: adaptiveWidth(constant))
    }
    
    func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor,
                        constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.trailingAnchor.constraint(equalTo: anchor,
                                              constant: adaptiveWidth(constant))
    }
    
    func heightAnchor(equalTo constant: CGFloat) -> NSLayoutConstraint {
        return self.heightAnchor.constraint(equalToConstant: adaptiveHeight(constant))
    }
    
    func widthAnchor(equalTo constant: CGFloat) -> NSLayoutConstraint {
        return self.widthAnchor.constraint(equalToConstant: adaptiveWidth(constant))
    }
    
    fileprivate func adaptiveHeight(_ height: CGFloat) -> CGFloat {
        return UIView.getAdaptiveHeight(height)
    }
    
    fileprivate func adaptiveWidth(_ width: CGFloat) -> CGFloat {
        return UIView.getAdaptiveWidth(width)
    }
    
    static func getAdaptiveHeight(_ height: CGFloat, ratio: CGFloat = 0.0) -> CGFloat {
        let screen = UIScreen.main.bounds
        let computedRatio = screen.size.height / referenceSize.height
        let customRatio = ratio > 0.0 ? ratio : computedRatio
        let screenRatio = (computedRatio > 1.0) ? customRatio : computedRatio
        return screenRatio * height
    }
    
    static func getAdaptiveWidth(_ width: CGFloat) -> CGFloat {
        let screen = UIScreen.main.bounds
        let screenRatio = screen.size.width / referenceSize.width
        return screenRatio * width
    }
    
}
