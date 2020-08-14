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
            badgeButton.categoryLabel.text = "Podcast details"
        }
    }
    
    static let cellId = "cellId"
    
    let episodeTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .softDark
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let episodeDescription:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel = SubtitleLabel(text: "21-Jun-2018", size: 12)
    let durationLabel = SubtitleLabel(text: "17m 38s", size: 12)
    let badgeButton = Badge()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews(){
//        backgroundColor = .black
        [episodeTitle, episodeDescription, dateLabel, durationLabel, badgeButton].forEach{addSubview($0)}
        
        badgeButton.containerView.layer.borderWidth = 0
        badgeButton.containerView.backgroundColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1)
        badgeButton.categoryLabel.textColor = .white
        
        episodeTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 12))
        dateLabel.anchor(top: episodeDescription.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        durationLabel.anchor(top: episodeDescription.bottomAnchor, leading: dateLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 12, bottom: 0, right: 0))
        
        badgeButton.anchor(top: episodeDescription.bottomAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 0), size: .init(width: 120, height: 0))
        
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


