//
//  SearchCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit
import SDWebImage

class SearchCell: UICollectionViewCell {
    
    var podcast:Podcast?{
        didSet{
            guard let podcast = podcast else{ return }
            guard let imageUrl = URL(string: podcast.artworkUrl600) else {return}
            leftImage.sd_setImage(with: imageUrl)
            authorLabel.text = podcast.artistName
            podcastLabel.text = podcast.trackName
            badge.categoryLabel.text = podcast.primaryGenreName
        }
    }
    
    static let reusableId = "SearchCell"
    lazy var leftImage = RoundedImageView(image: #imageLiteral(resourceName: "art"))
    let badge = Badge()
    var podcastLabel = TitleLabel(title: "This will be an amazing podcast", size: 16)
    let authorLabel = SubtitleLabel(text: "Joe Rogan", size: 13)
    var overallStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
        configureShadow()
    }
    
    fileprivate func configureShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.07
        layer.shadowOffset = .init(width: 3, height: 3)
        layer.shadowRadius = 6
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    fileprivate func configureUI(){
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 14
//        clipsToBounds = true
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
