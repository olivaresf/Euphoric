//
//  SeachController.swift
//  Euphoric
//
//  Created by Diego Oruna on 11/08/20.
//

import UIKit

class SearchController: CustomViewController {
    
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        configureCollectionView()
    }
    
    fileprivate func configureNavbar(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
}

extension SearchController:UICollectionViewDelegate{
        
}
