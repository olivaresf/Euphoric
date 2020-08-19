//
//  SeachController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

enum Section {
    case main
}

class SearchController: UIViewController {
    
    var collectionView:UICollectionView!
    let searchBar = CustomSearchBar(placeholder: "Listen your favorite podcast")
    var podcasts:[Podcast] = []
    var dataSource:UICollectionViewDiffableDataSource<Section,Podcast>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
//        setupNavbar(title: "Search")
        configureSearchBar()
        configureDataSource()
        view.backgroundColor = .systemBackground
        
        NetworkManager.shared.getPodcasts(for: "Joe") {[weak self] (result) in
            
            guard let self = self else {return}
            switch result{
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let podcasts):
                self.podcasts = podcasts
                self.updateData()
            }
        }
        
    }
    
    func configureSearchBar(){
        view.addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    fileprivate func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reusableId)
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, podcast) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reusableId, for: indexPath) as! SearchCell
            cell.podcast = podcast
            
            self.addInteraction(toCell: cell)
            
            return cell
        })
    }
    
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Podcast>()
        snapshot.appendSections([.main])
        snapshot.appendItems(podcasts)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    var timer: Timer?
    
}

extension SearchController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let formattedText = searchText.replacingOccurrences(of: " ", with: "+")
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            NetworkManager.shared.getPodcasts(for: formattedText) {[weak self] (result) in
                
                guard let self = self else {return}
                switch result{
                case .failure(let err):
                    print(err.localizedDescription)
                case .success(let podcasts):
                    self.podcasts = podcasts
                    self.updateData()
                }
            }
        })
    }
    
    private func addInteraction(toCell cell: UICollectionViewCell) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
    
}

extension SearchController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PodcastController()
        view.endEditing(true)
        vc.podcast = podcasts[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
//        let offset = scrollView.contentOffset.y + safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//        
//        if UIDevice.current.hasNotch{
//            searchBar.transform = .init(translationX: 0, y: min(0, max(-offset, -safeAreaTop)))
//        }else{
//            searchBar.transform = .init(translationX: 0, y: min(0, max(-offset, -safeAreaTop - 24)))
//        }
        
//        let alpha = 1 - (offset / safeAreaTop)
//        mainTitle.alpha = alpha
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20 - 20, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 74, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension SearchController:UIContextMenuInteractionDelegate{
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                // do whatever actions you want to perform...
            }
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                // do whatever actions you want to perform...
            }
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                // do whatever actions you want to perform...
            }
            return UIMenu(title: "", children: [shareAction, editAction, deleteAction])
        }
        
    }
    
    
}