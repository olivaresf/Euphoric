//
//  TopCategoriesCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import UIKit

class TopCategoriesCell: UICollectionViewCell {
    
    
    
    var category:Category?{
        didSet{
            guard let category = category else {return}
            categoryImage.image = category.image
            categoryLabel.text = category.name
        }
    }
    
    static let reusableId = "topCategoriesId"
    let categoryImage = RoundedImageView(image: #imageLiteral(resourceName: "headphones"))
    let textContainer:UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        var blurEffect = UIBlurEffect()
        var blurredEffectView = UIVisualEffectView()
        blurEffect = UIBlurEffect(style: .extraLight)

        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        
        return view
    }()
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .normalDark
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryImage)
        categoryImage.fillSuperview()
        
        addSubview(textContainer)
        textContainer.anchor(top: nil, leading: categoryImage.leadingAnchor, bottom: categoryImage.bottomAnchor, trailing: categoryImage.trailingAnchor, padding: .zero, size: .init(width: 0, height: 36))
        
        textContainer.addSubview(categoryLabel)
        categoryLabel.centerYTo(textContainer.centerYAnchor)
        categoryLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
