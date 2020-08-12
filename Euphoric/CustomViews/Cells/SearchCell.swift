//
//  SearchCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    static let reusableId = "SearchCell"
    lazy var leftImage = RoundedImageView(image: UIImage(named: "person")!)
    let badge = CategoryBadge()
    let podcastLabel = TitleLabel(title: "Sales for founders The Podcast Compnay ")
    let authorLabel = SubtitleLabel(text: "Brian Voong and company")
    var overallStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    fileprivate func configureUI(){
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        layer.cornerRadius = 14
        clipsToBounds = true
    }
    
    fileprivate func configureLayout(){
        addSubview(leftImage)
        addSubview(badge)

        NSLayoutConstraint.activate([
            leftImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leftImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            leftImage.widthAnchor.constraint(equalToConstant: 84),
        ])
    
        [podcastLabel, authorLabel, badge].forEach({overallStackView.addArrangedSubview($0)})
        
        addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 0).isActive = true
        overallStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 0, trailing: 24)
        
        overallStackView.axis = .vertical
        overallStackView.distribution = .fill
        overallStackView.spacing = 6
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
