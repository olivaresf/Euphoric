//
//  SearchCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    static let reusableId = "SearchCell"
    let leftImage = RoundedImageView(image: UIImage(named: "person")!)
    let textx = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    
    fileprivate func configureUI(){
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.cornerRadius = 14
        clipsToBounds = true
//        contentMode = .scaleAspectFill
    }
    
    fileprivate func configureLayout(){
        addSubview(leftImage)
        addSubview(textx)
        textx.text = "xdsxdsds"
        textx.textColor = .blue
        textx.translatesAutoresizingMaskIntoConstraints = false
//        sendSubviewToBack(leftImage)
        NSLayoutConstraint.activate([
            leftImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leftImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            leftImage.widthAnchor.constraint(equalToConstant: 66),
            
            textx.centerYAnchor.constraint(equalTo: centerYAnchor),
            textx.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
