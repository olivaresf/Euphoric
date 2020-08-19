//
//  TopShowsCell.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import UIKit

class TopPodcastCell: UICollectionViewCell {
    
    static let reusableId = "topShowsId"
    let showImage = RoundedImageView(image: #imageLiteral(resourceName: "headphones"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(showImage)
        showImage.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
