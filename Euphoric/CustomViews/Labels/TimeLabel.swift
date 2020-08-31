//
//  TimeLabel.swift
//  Euphoric
//
//  Created by Diego Oruna on 30/08/20.
//

import UIKit

class TimeLabel: UILabel {
    
    convenience init() {
        self.init()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
