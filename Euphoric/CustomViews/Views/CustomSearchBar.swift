//
//  CustomSearchBar.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(placeholder:String) {
        self.init()
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(){
        directionalLayoutMargins = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        searchBarStyle = .minimal
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "blueBackground")
        setImage(UIImage(systemName: "mic"), for: .search, state: .normal)
        returnKeyType = .done
    }
    
}
