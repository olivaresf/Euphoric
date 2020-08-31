//
//  EpisodeCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 13/08/20.
//

import UIKit

//protocol EpisodeCellDelegate {
//    func didTapMore(episode:Episode)
//}

class EpisodeCell: UITableViewCell {
    
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
//    var delegate:EpisodeCellDelegate?
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        layer.cornerRadius = 14
        backgroundColor = .secondarySystemGroupedBackground
        [dateLabel, episodeTitle, episodeDescription].forEach{addSubview($0)}
//
        dateLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 0))
        episodeTitle.anchor(top: dateLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 0, right: 18))
        episodeDescription.anchor(top: episodeTitle.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 8, bottom: 8, right: 28))
        
    }
    
}
