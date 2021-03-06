//
//  CategoryBadge.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class Badge: UIView {
    
    let userDefaults = UserDefaults.standard
    
    lazy var containerView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 0.5
        view.layer.borderColor = userDefaults.colorForKey(key: "tintColor")?.cgColor ?? UIColor.systemPink.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var categoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Technology"
        label.textColor = userDefaults.colorForKey(key: "tintColor") ?? .systemPink
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(color:UIColor) {
        self.init()
        containerView.layer.borderColor = color.cgColor
        categoryLabel.textColor = color
    }
    
    func setupUI(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        clipsToBounds = true
        
        containerView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            
            containerView.heightAnchor.constraint(equalToConstant: 22),
            
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
