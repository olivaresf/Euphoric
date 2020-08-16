//
//  PodcastController.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import UIKit

enum Section2:Hashable {
    case main
}

class PodcastController: CustomViewController {
    
    var podcast:Podcast?{
        didSet{
            fetchEpisodes()
        }
    }
    
    var collectionView:UICollectionView!
    var episodes: [Episode] = []
    let activityView = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let heartItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart.fill"), style: .done, target: self, action: #selector(handleHeart))
        let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(handleHeart))
        navigationItem.rightBarButtonItems = [heartItem, moreItem]
        let layout = collectionView.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: collectionView.widestCellWidth,
                height: 40
            )
        }
    }
    
    @objc func handleHeart(){
        
    }
    
    func fetchEpisodes(){
        guard let feedUrl = podcast?.feedUrl else { return }
        NetworkManager.shared.fetchEpisodes(feedUrl: feedUrl) { [weak self] (episodes) in
            
            guard let self = self else { return }
            
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.collectionView.reloadData()
            }
            
        }
        
    }
    
    var episode:Episode?

    func setupCollectionView(){
        
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.headerReferenceSize = .init(width: view.frame.width, height: 280)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: customFlowLayout)
        view.addSubview(collectionView)
        view.addSubview(activityView)
        
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        
        collectionView.contentInset = .init(top: 0, left: 18, bottom: 18, right: 18)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(PodcastHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PodcastHeaderCell.cellId)
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.transform = .identity
    }

    
    
}

extension PodcastController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let searchController = rootController?.viewControllers.first as? SearchController
        
        var selectedEpisode = episodes[indexPath.item]
        
        if selectedEpisode.author.isEmpty{
            selectedEpisode.author = podcast?.artistName ?? ""
        }
        
        searchController?.setEpisode(episode: selectedEpisode)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.cellId, for: indexPath) as! EpisodeCell
        self.episode = self.episodes[indexPath.item]
        cell.episode = episode
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PodcastHeaderCell.cellId, for: indexPath) as! PodcastHeaderCell
        
        sectionHeader.podcast = self.podcast
        sectionHeader.podcastDescription.text = self.episode?.description
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
}

extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}
