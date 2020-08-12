//
//  SeachController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SearchController: CustomViewController {
    
    var collectionView:UICollectionView!
    let searchBar = CustomSearchBar(placeholder: "Listen your favorite podcast")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupNavbar(title: "Search")
        configureSearchBar()
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
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reusableId)
    }
    
}

extension SearchController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text ?? "")
    }
    
}

extension SearchController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CustomViewController()
        
        vc.title = "xd"
        let nav = UINavigationController(rootViewController: vc)
        
//        navigationController?.pushViewController(vc, animated: true)
        present(nav, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let offset = scrollView.contentOffset.y + safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        if UIDevice.current.hasNotch{
            searchBar.transform = .init(translationX: 0, y: min(0, max(-offset, -safeAreaTop)))
        }else{
            searchBar.transform = .init(translationX: 0, y: min(0, max(-offset, -safeAreaTop - 24)))
        }
        
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
        return CGSize(width: view.frame.width - 20 - 20, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 74, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
