//
//  CategoryBadge.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class CategoryBadge: UIView {
    
    let containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemPurple.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Technology"
        label.textColor = .systemPurple
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        clipsToBounds = true
        
        containerView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            containerView.heightAnchor.constraint(equalToConstant: 15),
            
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
