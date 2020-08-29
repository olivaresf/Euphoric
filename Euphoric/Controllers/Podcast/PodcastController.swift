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

class PodcastController: UITableViewController {
    
    //MARK:- Variables
    let cellId = "cellId"
    
    var podcast:Podcast?{
        didSet{
            fetchEpisodes()
        }
    }
    
    var episodes: [Episode] = []
    var episode:Episode?
    
    let activityView = UIActivityIndicatorView(style: .medium)
    var heartItem:UIBarButtonItem!
    
    let moreItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(handleHeart))
    
    //MARK:- Lifecycle Methods
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        heartItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .done, target: self, action: #selector(handleHeart))
        navigationItem.rightBarButtonItems = [heartItem, moreItem]
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
                self.tableView.reloadData()
            }
        }
        
    }
    
    //MARK:- TableView Setup
    
    func setupTableView(){
        tableView.backgroundColor = UIColor(named: "blueBackground")
        tableView.register(EpisodeDownlodedCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.contentInset.bottom = 70
        tableView.sectionHeaderHeight = 240
        
        view.addSubview(activityView)

        activityView.centerInSuperview()
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeDownlodedCell
        self.episode = self.episodes[indexPath.item]
        cell.episode = episode
        self.addInteraction(toCell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let homeController = rootController?.viewControllers.first as? HomeController

        var selectedEpisode = episodes[indexPath.item]

        if selectedEpisode.author.isEmpty{
            selectedEpisode.author = podcast?.artistName ?? ""
        }

        homeController?.setEpisode(episode: selectedEpisode)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let podcastHeader = PodcastHeaderView()
        podcastHeader.podcast = podcast
        return podcastHeader
    }
    
    private func addInteraction(toCell cell: UITableViewCell) {
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

extension PodcastController:UIContextMenuInteractionDelegate{
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let episode = episodes[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return UIMenu(title: "", children: [self.shareAction(episode: episode), self.downloadAction(episode: episode)])
        }
    }

}

