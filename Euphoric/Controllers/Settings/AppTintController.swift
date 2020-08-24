//
//  AppTintController.swift
//  Euphoric
//
//  Created by Diego Oruna on 21/08/20.
//

import UIKit

//enum SystemColors:UIColor,CaseIterable {
//    case UIColor.red
//}

class AppTintController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var availableColors = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 12, left: 18, bottom: 18, right: 12)
        
        [UIColor.systemBlue, .systemRed, .systemPink].forEach{availableColors.append($0)}
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableColors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor  = availableColors[indexPath.item]
        cell.layer.cornerRadius = 18
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDefault = UserDefaults.standard
        let cell = collectionView.cellForItem(at: indexPath)
        userDefault.setColor(color: cell?.backgroundColor, forKey: "tintColor")
//        dismiss(animated: true)
        dismiss(animated: true) {
            self.view.setNeedsDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width / 3.0
        let yourHeight = yourWidth
        return CGSize(width: yourWidth - (12 * 2), height: yourHeight - (12 * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
}
