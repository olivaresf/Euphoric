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
    
    convenience init(title:String, size: CGFloat, alignment:NSTextAlignment = .left) {
        self.init()
        textAlignment = alignment
        text = title
        font = UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 2
        lineBreakMode = .byTruncatingTail
        textColor = UIColor(named: "primaryColor")
    }
    
}
