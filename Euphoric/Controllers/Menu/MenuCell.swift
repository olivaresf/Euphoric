//
//  MenuCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "Menu Item"
        l.textAlignment = .center
        l.textColor = .tertiaryLabel
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return l
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor(named: "primaryLabel") : .tertiaryLabel
            label.font = isSelected ? UIFont.systemFont(ofSize: 17, weight: .heavy) : UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.fillSuperview()
        backgroundColor = UIColor(named: "blueBackground")
    }
    
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
