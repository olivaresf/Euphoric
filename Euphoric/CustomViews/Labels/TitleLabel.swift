//
//  TitleTextField.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title:String) {
        self.init()
        text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        numberOfLines = 2
        lineBreakMode = .byTruncatingTail
        font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textColor = .normalDark
    }
    
}
