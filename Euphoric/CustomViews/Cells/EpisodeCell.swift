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
            customLabel.text = "XDXDXD"
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
    
    let customLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .softDark
//        label.numberOfLines = 2
//        label.text = "xdxdxdxd"
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
    
    let dateLabel = SubtitleLabel(text: "21-Jun-2018", size: 11)
    let durationLabel = SubtitleLabel(text: "17m 38s", size: 11)
    let badgeButton = Badge()
    let episodeImage = RoundedImageView(image: #imageLiteral(resourceName: "play"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews(){
//        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        [episodeTitle, episodeDescription, dateLabel, durationLabel, episodeImage ].forEach{addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            episodeImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        episodeImage.constrainWidth(40)
        episodeImage.constrainHeight(40)
        
        episodeTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeImage.leadingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: 28))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeImage.leadingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 28))
        dateLabel.anchor(top: episodeDescription.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        durationLabel.anchor(top: episodeDescription.bottomAnchor, leading: dateLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0))
        
//        customLabel.anchor(top: dateLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 14, bottom: 0, right: 0), size: .init(width: 0, height: 10))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // Replace the height in the target size to
        // allow the cell to flexibly compute its height
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        // The .required horizontal fitting priority means
        // the desired cell width (targetSize.width) will be
        // preserved. However, the vertical fitting priority is
        // .fittingSizeLevel meaning the cell will find the
        // height that best fits the content
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    
}
