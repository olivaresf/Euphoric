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
    
    convenience init(text:String, size:CGFloat) {
        self.init()
        self.text = text
        font = UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        numberOfLines = 2
        lineBreakMode = .byTruncatingTail
    }
    
}
