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
        l.textColor = .lightGray
        return l
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .normalDark : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.fillSuperview()
    }
    
    
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
