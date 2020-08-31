//
//  CustomLabel.swift
//  Euphoric
//
//  Created by Diego Oruna on 30/08/20.
//

import UIKit

class CustomLabel: UILabel {
    
    convenience init(text:String, size:CGFloat, weight:UIFont.Weight, textColor:UIColor, numberOfLines:Int = 0, textAlignment:NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
