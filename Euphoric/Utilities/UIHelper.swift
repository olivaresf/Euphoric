//
//  UIHelper.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

struct UIHelper {
    
    static func createCardsFlowLayout(in view:UIView) -> UICollectionViewFlowLayout{
        
        let width = view.bounds.width
        let padding:CGFloat = 12
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: padding, left: padding, bottom: -padding, right: padding)
        flowLayout.itemSize = .init(width: width, height: 88)
        
        return flowLayout
        
    }
}
