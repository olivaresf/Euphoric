//
//  HomeController.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MenuControllerDelegate, DiscoverControllerDelegate {
    
    func didTapMenuItem(_ indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func didTapItem(){
        print("tapping cell")
    }
    
    @objc func handleSearch(){
        let searchVC = SearchController()
//        self.navigationController?.pushViewController(searchVC, animated: true)
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true)
    }
    
    @objc func handleSettings(){
        let settingsVC = SettingsController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
    }
    
    let menuController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let cellID = "cellId"
    fileprivate let colors: [UIColor] = [.red, .green, .blue]
    
    let playerDetailsController = PlayerDetailsController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Euforic"
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(handleSearch))
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [search, settings]
        navigationItem.rightBarButtonItems?.forEach({$0.tintColor = .darkGray})
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        menuController.delegate = self
        menuController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        collectionView.allowsSelection = true
        
        setupLayout()
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        
        //
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        window?.addSubview(playerDetailsController.view)
        
        addChild(playerDetailsController)
        playerDetailsController.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        playerDetailsController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        playerDetailsController.showPlayerDetail()
        
    }
    
    func setEpisode(episode:Episode){
        playerDetailsController.episode = episode
    }
    
    func showPlayer(){
//        playerDetailsController.showPlayerDetail()
    }
    
    
    fileprivate func setupLayout() {
        let menuView = menuController.view!

        view.addSubview(menuView)
        menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 60))
        
        collectionView.backgroundColor = .white
        collectionView.anchor(top: menuView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x / 3
        menuController.menuBar.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = x / view.frame.width
        let indexPath = IndexPath(item: Int(item), section: 0)
        menuController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainCell
        cell.backgroundColor = colors[indexPath.item]
        cell.discoverController.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let statusBar = statusBarHeight()
        let topSafeArea = view.safeAreaInsets.top
//        let bottomSafeArea = view.safeAreaInsets.bottom

        return .init(width: view.frame.width, height: view.frame.height - 60 - topSafeArea)
    }
    
    func statusBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let statusBarSize = window?.windowScene?.statusBarManager?.statusBarFrame else {return 0}
        return min(statusBarSize.width, statusBarSize.height)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//
}



class MainCell: UICollectionViewCell {
    
    let discoverController = DiscoverController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let newsItemsView = discoverController.view!
        addSubview(newsItemsView)
        newsItemsView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


