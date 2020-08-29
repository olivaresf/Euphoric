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
    
    //MARK:- Variables
    
    var podcast:Podcast?{
        didSet{
            fetchEpisodes()
        }
    }
    
    var collectionView:UICollectionView!
    var episodes: [Episode] = []
    var episode:Episode?
    
    let activityView = UIActivityIndicatorView(style: .large)
    var heartItem:UIBarButtonItem!
    
    let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(handleHeart))
    
    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        heartItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .done, target: self, action: #selector(handleHeart))
        navigationItem.rightBarButtonItems = [heartItem, moreItem]
        
        let layout = collectionView.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: widestCellWidth,
                height: 40
            )
        }
    }
    
    override func viewWillLayoutSubviews() {
        setupHeart()
    }
    
    //MARK:- Functions
    
    func setupHeart(){
        let listOfPodcasts = UserDefaults.standard.savedPodcasts()
        
        guard let podcast = podcast else {return}
        
        for p in listOfPodcasts {
            if p.trackName == podcast.trackName && p.artistName == podcast.artistName{
                heartItem.image = UIImage(systemName: "suit.heart.fill")
                break
            }else{
                heartItem.image = UIImage(systemName: "suit.heart")
            }
        }
        
    }
    
    @objc func handleHeart(){
        let notificationName = Notification.Name(rawValue: favoritedNotificationKey)
        
        guard let podcast = self.podcast else {return}
        let listOfPodcasts = UserDefaults.standard.savedPodcasts()
        
        if listOfPodcasts.isEmpty{
            savePodcastToUserDefault(podcast)
            heartItem.image = UIImage(systemName: "suit.heart.fill")
            NotificationCenter.default.post(name: notificationName, object: nil)
            return
        }else{
            
            for p in listOfPodcasts{
                if p.trackName == podcast.trackName && p.artistName == podcast.artistName{
                    UserDefaults.standard.deletePodcast(p)
                    heartItem.image = UIImage(systemName: "suit.heart")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    return
                }
            }
            
            savePodcastToUserDefault(podcast)
            heartItem.image = UIImage(systemName: "suit.heart.fill")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
    }
    
    //MARK:- Handle User Defaults
    
    func savePodcastToUserDefault(_ podcast:Podcast){
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        } catch let err {
            print(err)
        }
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
    
    //MARK:- CollectionView Setup
    
    var widestCellWidth: CGFloat {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        return collectionView.bounds.width - insets
    }
    
    func setupCollectionView(){
        
        let customFlowLayout = UICollectionViewFlowLayout()
        customFlowLayout.headerReferenceSize = .init(width: view.frame.width, height: 230)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: customFlowLayout)
        view.addSubview(collectionView)
        view.addSubview(activityView)
        
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        
        collectionView.contentInset = .init(top: 0, left: 18, bottom: 180, right: 18)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "blueBackground")
        collectionView.register(PodcastHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PodcastHeaderCell.cellId)
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.cellId)
    }
    
    private func addInteraction(toCell cell: UICollectionViewCell) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
    
    //MARK:- Context Menu Actions
    
    func downloadAction(episode:Episode) -> UIAction {
        return UIAction(title: "Download", image: UIImage(systemName: "square.and.pencil")) { _ in
            UserDefaults.standard.downloadEpisode(episode: episode)
            NetworkManager.shared.downloadEpisode(episode: episode)
        }
    }
    
    func shareAction(episode:Episode) -> UIAction {
        return UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            
            let message = "\(episode.title): \(episode.streamUrl)"
            
            let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
            
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
            
        }
    }
    
}

extension PodcastController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let searchController = rootController?.viewControllers.first as? HomeController
        
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
        cell.delegate = self
        self.addInteraction(toCell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PodcastHeaderCell.cellId, for: indexPath) as! PodcastHeaderCell
        
        sectionHeader.podcast = self.podcast
        sectionHeader.podcastDescription.text = self.episode?.description
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
}


extension PodcastController:UIContextMenuInteractionDelegate{
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let episode = episodes[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return UIMenu(title: "", children: [self.shareAction(episode: episode), self.downloadAction(episode: episode)])
        }
        
    }
    
}


extension PodcastController:EpisodeCellDelegate{
    func didTapMore(episode: Episode) {
        print(episode.author)
    }
    
}


