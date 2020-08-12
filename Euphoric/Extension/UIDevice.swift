//
//  UIDevice.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

