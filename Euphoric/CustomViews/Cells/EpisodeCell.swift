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
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .normalDark
        label.numberOfLines = 2
        label.text = "El vaso medio lleno - Episodio Dia 73"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let episodeDescription:UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .normalDark
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a very impressive podcast title and I really want to be part of this to set this to ne part of that but is very difficult that but is very difficult that but is very difficult"
        return label
    }()
    
    let dateLabel = SubtitleLabel(text: "21-Jun-2018", size: 12)
    let durationLabel = SubtitleLabel(text: "17m 38s", size: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews(){
        [episodeTitle, episodeDescription, dateLabel].forEach{addSubview($0)}

        
        episodeTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 12))
        dateLabel.anchor(top: episodeDescription.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
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


