//
//  EpisodeDownlodedCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 24/08/20.
//

import UIKit

class EpisodeDownlodedCell: UITableViewCell {
    
    var episode:Episode?{
        didSet{
            guard let episode = episode else {return}
            guard let imageUrl = episode.imageUrl else {return}
            leftImage.sd_setImage(with: URL(string: imageUrl))
            podcastLabel.text = episode.title
            descriptionLabel.text = episode.description
        }
    }
    
    static let reusableId = "SearchCell"
    lazy var leftImage = RoundedImageView(image: #imageLiteral(resourceName: "art"))
    var podcastLabel = TitleLabel(title: "This will be an amazing podcast", size: 16)
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    let progressLabel:UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    var overallStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureUI()
    }
    
    fileprivate func configureUI(){
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 14
    }
    
    fileprivate func configureLayout(){
        addSubview(leftImage)

        NSLayoutConstraint.activate([
            leftImage.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leftImage.widthAnchor.constraint(equalToConstant: 62),
            leftImage.heightAnchor.constraint(equalToConstant: 62),
        ])
    
        [podcastLabel, descriptionLabel].forEach({overallStackView.addArrangedSubview($0)})
        
        addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 0).isActive = true
        overallStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        overallStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        overallStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.directionalLayoutMargins = .init(top: 0, leading: 12, bottom: 12, trailing: 24)
        
        overallStackView.axis = .vertical
        overallStackView.distribution = .fill
        overallStackView.spacing = 6
        
//        leftImage.layer.opacity = 0.5
        addSubview(progressLabel)
        progressLabel.centerXTo(leftImage.centerXAnchor)
        progressLabel.centerYTo(leftImage.centerYAnchor)
        progressLabel.bringSubviewToFront(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
