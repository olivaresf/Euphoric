//
//  EpisodeCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 13/08/20.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    var episode:Episode?{
        didSet{
            guard let episode = episode else {return}
            episodeTitle.text = episode.title
            episodeDescription.text = episode.description
        }
    }
    
    static let cellId = "cellId"
    
    let episodeTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(named: "primaryLabel")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    let episodeDescription:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel = SubtitleLabel(text: "21-Jun-2018", size: 10)
    let durationLabel = SubtitleLabel(text: "17m 38s", size: 10)
    let badgeButton = Badge()
    let episodeImage = RoundedImageView(image: #imageLiteral(resourceName: "play"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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

    func setupViews(){
        backgroundColor = UIColor(named: "blueBackground")
        layer.cornerRadius = 12
        [episodeTitle, episodeDescription, dateLabel, durationLabel, episodeImage ].forEach{addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            episodeImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        episodeImage.constrainWidth(25)
        episodeImage.constrainHeight(30)
        episodeImage.layer.opacity = 0
        
        episodeTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeImage.leadingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: 28))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeImage.leadingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 28))
        dateLabel.anchor(top: episodeDescription.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        durationLabel.anchor(top: episodeDescription.bottomAnchor, leading: dateLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    
}
