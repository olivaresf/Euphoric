//
//  PodcastHeaderCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import UIKit

class PodcastHeaderCell: UICollectionReusableView {
    
    var podcast:Podcast?{
        didSet{
            guard let podcast = podcast else {return}
            podcastLabel.text = podcast.trackName
            podcastImage.sd_setImage(with: URL(string: podcast.artworkUrl600))
            episodesAvailableLabel.text = "\(podcast.trackCount) Episodes available"
            authorLabel.text = podcast.artistName
            categoryBadge.categoryLabel.text = podcast.primaryGenreName
            print(podcast.feedUrl)
        }
    }
    
    let podcastImage = RoundedImageView(image: #imageLiteral(resourceName: "person"))
    let podcastLabel = TitleLabel(title: "This is a very impressive podcast title", size: 24)
    let episodesAvailableLabel = SubtitleLabel(text: "2 Episodes available", size: 15)
    let authorLabel = TitleLabel(title: "Diego Isco", size: 18)
    let categoryBadge = Badge(color: .systemPink)
//    let explicitBadge = Badge(color: .systemRed)
    var infoStackView:UIStackView!
    static let cellId = "PodcastHeaderId"
    
    let podcastDescription:UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a very impressive podcast title and I really want to be part of this to set this to ne part of that but is very difficult that but is very difficult that but is very difficult"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout(){
//        backgroundColor = .systemTeal
        [podcastLabel, episodesAvailableLabel, podcastImage, categoryBadge, authorLabel, podcastDescription].forEach{addSubview($0)}
        
        let padding:CGFloat = 14
        
        let imageSize:CGFloat
        
        if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard{
            imageSize = frame.width / 2 - 52
        }else{
            imageSize = 150
        }
        
        podcastLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: 0, bottom: 0, right: 0))
        episodesAvailableLabel.anchor(top: podcastLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: 0, bottom: 0, right: 0))
        podcastImage.anchor(top: episodesAvailableLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: padding, left: 0, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
    
        categoryBadge.anchor(top: podcastImage.topAnchor, leading: podcastImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding) ,size: .init(width: 0, height: 18))
        authorLabel.anchor(top: categoryBadge.bottomAnchor, leading: podcastImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 7, left: padding, bottom: 0, right: 0))
        podcastDescription.anchor(top: authorLabel.bottomAnchor, leading: podcastImage.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 7, left: padding, bottom: 0, right: 0))
        
    }
    
}