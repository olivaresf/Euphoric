//
//  DownloadsController.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import SwiftUI

class ListenNowController: UITableViewController {
    
    var episodes = UserDefaults.standard.listenedEpisodes()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataModification), name: .listenNowModified, object: nil)
    }
    
    @objc func handleDataModification(){
        episodes = UserDefaults.standard.listenedEpisodes()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor(named: "blueBackground")
        tableView.register(EpisodeDownlodedCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EpisodeDownlodedCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            let selectedEpisode = self.episodes[indexPath.row]
            
            DispatchQueue.main.async {
                self.episodes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaults.standard.deleteListenedEpisode(for: selectedEpisode)
            }
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
//
//            let selectedEpisode = self.episodes[indexPath.row]
//
//            DispatchQueue.main.async {
//                self.episodes.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                UserDefaults.standard.deleteListenedEpisode(for: selectedEpisode)
//            }
//
//        }
//        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
//
//        return swipeActions
//    }
    
}

