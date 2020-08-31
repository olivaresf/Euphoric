//
//  EpisodeCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 13/08/20.
//

import UIKit

protocol EpisodeCellDelegate {
    func didTapMore(episode:Episode)
}

class EpisodeCell: UICollectionViewCell {
    
    var episode:Episode?{
        didSet{
            guard let episode = episode else {return}
            episodeTitle.text = episode.title
            episodeDescription.text = episode.description
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "MMM d, yyyy"
            dateLabel.text = formatter4.string(from: episode.pubDate)
        }
    }
    
    static let cellId = "cellId"
    var delegate:EpisodeCellDelegate?
    
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
    
    let dateLabel = SubtitleLabel(text: "21-Jun-2018", size: 12)
    let durationLabel = SubtitleLabel(text: "17m 38s", size: 12)
    let badgeButton = Badge()

    let episodeAccesory:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage.withSymbol(type: .dots, weight: .regular), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    @objc func handleAccesory(){
        delegate?.didTapMore(episode: self.episode!)
    }

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
        episodeAccesory.addTarget(self, action: #selector(handleAccesory), for: .touchUpInside)
        self.contentView.isUserInteractionEnabled = false
        backgroundColor = UIColor(named: "blueBackground")
        [episodeTitle, episodeDescription, dateLabel, episodeAccesory].forEach{addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            episodeAccesory.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeAccesory.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        episodeAccesory.constrainWidth(60)
        episodeAccesory.constrainHeight(60)
        episodeAccesory.tintColor = UserDefaults.standard.colorForKey(key: "tintColor") ?? .systemPink
        episodeAccesory.layer.opacity = 1
        
        episodeTitle.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeAccesory.leadingAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: 18))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: episodeAccesory.leadingAnchor, padding: .init(top: 6, left: 0, bottom: 0, right: 28))
        dateLabel.anchor(top: episodeDescription.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
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
