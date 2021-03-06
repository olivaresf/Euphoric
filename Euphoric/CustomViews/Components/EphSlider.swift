//
//  EphSlider.swift
//  Euphoric
//
//  Created by Diego Oruna on 30/08/20.
//

import UIKit

class EphSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        tintColor = .normalDark
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
