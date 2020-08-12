//
//  SubtitleLabel.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SubtitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(text:String) {
        self.init()
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textColor = UIColor.darkGray
        numberOfLines = 2
        lineBreakMode = .byTruncatingTail
    }
    
}
