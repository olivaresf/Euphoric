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
        
        var selectedEpisode = episodes[indexPath.item]
        
        dismiss(animated: true) {
            homeController?.setEpisode(episode: selectedEpisode)
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

