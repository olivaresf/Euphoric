//
//  SeachController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SearchController: CustomViewController {
    
    var collectionView:UICollectionView!
    lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupNavbar(title: "Search")
        configureSearchBar()
    }
    
    func configureSearchBar(){
        searchBar = UISearchBar()
        searchBar.directionalLayoutMargins = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        searchBar.placeholder = "Whatever you want"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.97)
        searchBar.setImage(UIImage(systemName: "music.note"), for: .search, state: .normal)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
//        view.bringSubviewToFront(searchView)
        
    }
    
    fileprivate func configureCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reusableId)
    }
    
}

extension SearchController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let offset = scrollView.contentOffset.y + safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        searchBar.transform = .init(translationX: 0, y: min(0, max(-offset, -safeAreaTop)))
        
        let alpha = 1 - (offset / safeAreaTop)
        mainTitle.alpha = alpha
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reusableId, for: indexPath) as! SearchCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 94)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 74, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

        
    
}
