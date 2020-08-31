//
//  DownloadsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 24/08/20.
//

import UIKit

class DownloadsController: UITableViewController {

    private let cellId = "cellId"
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupObservers()
    }
    
    fileprivate func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc fileprivate func handleDownloadProgress(notification:Notification){
        guard let userInfo = notification.userInfo as? [String:Any] else {return}
        guard let progress = userInfo["progress"] as? Double else {return}
        guard let title = userInfo["title"] as? String else {return}
        
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else {return }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeDownlodedCell else {return}
        cell.progressLabel.isHidden = false
        cell.leftImage.layer.opacity = 0.4
        cell.progressLabel.text = "\(Int(progress * 100))%"
        
        if progress == 1{
            cell.progressLabel.isHidden = true
            cell.leftImage.layer.opacity = 1
        }
        
    }
    
    @objc func handleDownloadComplete(notification:Notification){
        guard let episodeDownloadComplete = notification.object as? NetworkManager.EpisodeDownloadCompleteTuple else {return}
        
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else {return }
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func tableViewSetup() {
        title = "Downloads"
        tableView.backgroundColor = UIColor(named: "blueBackground")
        tableView.register(EpisodeDownlodedCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let homeController = rootController?.viewControllers.first as? HomeController
        
        let selectedEpisode = episodes[indexPath.item]
        
        if selectedEpisode.fileUrl != nil{
            dismiss(animated: true) {
                homeController?.setEpisode(episode: selectedEpisode, playlistEpisodes: self.episodes)
            }
        }else{
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.dismiss(animated: true) {
                    homeController?.setEpisode(episode: selectedEpisode, playlistEpisodes: self.episodes)
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alertController, animated: true)
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeDownlodedCell
        cell.episode = episodes[indexPath.item]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let selectedEpisode = self.episodes[indexPath.row]
            
            DispatchQueue.main.async {
                self.episodes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaults.standard.deleteDownloadedEpisode(for: selectedEpisode)
            }
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }

}

