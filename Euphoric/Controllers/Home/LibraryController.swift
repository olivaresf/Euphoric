//
//  LibraryController.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import UIKit

protocol LibraryControllerDelegate {
    func didTapLibraryPodcast(podcast:Podcast)
}

let favoritedNotificationKey = "co.diegois.favorited"

class LibraryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let favoritedNoti = Notification.Name(rawValue: favoritedNotificationKey)
    var delegate:LibraryControllerDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var podcasts = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = UIColor(named: "blueBackground")
        collectionView.contentInset = .init(top: 18, left: 0, bottom: 48, right: 0)
        collectionView.contentInset.bottom = 82
        createObservers()
        
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: favoritedNoti, object: nil)
    }
    
    @objc func reloadData(){
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SearchCell
        cell.podcast = podcasts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 36, height: 110)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapLibraryPodcast(podcast: podcasts[indexPath.item])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
}
