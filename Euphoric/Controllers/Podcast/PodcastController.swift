//
//  PodcastController.swift
//  Euphoric
//
//  Created by Diego Oruna on 12/08/20.
//

import UIKit
import Alamofire

enum Section2:Hashable {
    case main
}

class PodcastController: UITableViewController {
    
    //MARK:- Variables
    let cellId = "cellIdd"
    
    var podcast:Podcast?{
        didSet{
            alert.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    var episodes: [Episode] = []
    var numberOfItems:Int?{
        didSet{
            footerLabel.text = "Show all episodes (\(numberOfItems ?? 0))"
        }
    }
    var episode:Episode?
    
    let activityView = UIActivityIndicatorView(style: .medium)
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var heartItem:UIBarButtonItem!
    var dotsItem:UIBarButtonItem!
    
    lazy var footerLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var footerView:UIView = {
        let view = UIView()
        view.addSubview(footerLabel)
        footerLabel.centerInSuperview()
        return view
    }()
    
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
        setupAlerts()
        
        dotsItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(handleDots))
        heartItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .done, target: self, action: #selector(handleHeart))
        dotsItem.tintColor = UserDefaults.standard.colorForKey(key: "tintColor") ?? .systemPink
        heartItem.tintColor = UserDefaults.standard.colorForKey(key: "tintColor") ?? .systemPink
        navigationItem.rightBarButtonItems = [heartItem, dotsItem]
    }
    
    override func viewWillLayoutSubviews() {
        setupHeart()
    }
    
    let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)

    //MARK:- Functions
    
    func setupAlerts(){
        alert.view.tintColor = .label
        let shareAlert = UIAlertAction(title: "Share", style: .default) { (_) in
            guard let podcast = self.podcast else {return}
            self.share(title: podcast.trackName!, message: podcast.feedUrl!)
        }
        shareAlert.setValue(UIImage.withSymbol(type: .share, size: 20, weight: .regular), forKey: "image")
        alert.addAction(shareAlert)
    
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alert.addAction(dismissAction)
    }
    
    @objc func handleDots(){
        present(alert, animated: true)
    }
    
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
        generator.impactOccurred()
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
        NetworkManager.shared.fetchEpisodes(feedUrl: feedUrl, all: false) { [weak self] (episodes, numberOfItems, podcastDescription)   in
            guard let self = self else { return }
            self.episodes = episodes
            DispatchQueue.main.async {
                if numberOfItems > 50{
                    self.footerView.isHidden = false
                }
                self.numberOfItems = numberOfItems
                self.activityView.stopAnimating()
                self.tableView.reloadData()
                self.alert.message = podcastDescription?.htmlToString ?? ""
            }
        }
        
    }
    
    //MARK:- TableView Setup
    
    func setupTableView(){
        footerView.isHidden = true
        tableView.footerView(forSection: 0)?.isHidden = true
        tableView.backgroundColor = UIColor(named: "blueBackground")
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 900
        
        tableView.contentInset.bottom = 90
        
        tableView.sectionHeaderHeight = 220
        tableView.sectionFooterHeight = 60
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.selectionStyle = .none
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

        UserDefaults.standard.addEpisodeToListened(episode: selectedEpisode)
        NotificationCenter.default.post(name: .listenNowModified, object: nil)
        homeController?.setEpisode(episode: selectedEpisode, playlistEpisodes: self.episodes)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
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
    
    func share(title:String, message:String){
        let message = "\(title): \(message)"
        
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
    
    func shareAction(episode:Episode) -> UIAction {
        return UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.share(title: episode.title, message: episode.streamUrl)
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

