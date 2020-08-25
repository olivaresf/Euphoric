//
//  EpisodeDownlodedCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 24/08/20.
//

import UIKit

class EpisodeDownlodedCell: UITableViewCell {
    
    static let reusableId = "SearchCell"
    lazy var leftImage = RoundedImageView(image: #imageLiteral(resourceName: "art"))
    var podcastLabel = TitleLabel(title: "This will be an amazing podcast", size: 16)
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
//        label.text = "In this episode the people will try to implement a very nice feature with some kind weird table view cell"
        label.text = "In this episode the "
        label.numberOfLines = 3
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
//            leftImage.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        overallStackView.directionalLayoutMargins = .init(top: 12, leading: 12, bottom: 12, trailing: 24)
        
        overallStackView.axis = .vertical
        overallStackView.distribution = .fill
        overallStackView.spacing = 6
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
