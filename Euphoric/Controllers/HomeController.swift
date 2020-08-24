//
//  HomeController.swift
//  Euphoric
//
//  Created by Diego Oruna on 17/08/20.
//

import UIKit

class HomeController: UICollectionViewController {
        
    //MARK:- Hi
    let menuController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    var menuView = UIView()
    
    fileprivate let discoverCellId = "discoverCellId"
    fileprivate let libraryCellId = "libraryCellId"
    fileprivate let downloadsCellId = "downloadsCellId"
    
    var playerDetailsController = PlayerDetailsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupMenu()
        setupCollectionView()
        presentPlayerController()
    }
    
    @objc func handleSettings(){
        let settingsVC = SettingsController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
    }
    
    func setEpisode(episode:Episode){
        playerDetailsController.episode = episode
    }

    func presentPlayerController(){
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        window?.addSubview(playerDetailsController.view)

        addChild(playerDetailsController)
        playerDetailsController.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        playerDetailsController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)

        playerDetailsController.showPlayerDetail()
    }
    
    func setupMenu(){
        menuView = menuController.view!
        
        menuController.delegate = self
        menuController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        collectionView.allowsSelection = true
        
        view.addSubview(menuView)
        menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 60))
    }
    
    func setupCollectionView(){
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.register(dummyDiscoverCell.self, forCellWithReuseIdentifier: discoverCellId)
        collectionView.register(dummyLibraryCell.self, forCellWithReuseIdentifier: libraryCellId)
        collectionView.register(dummyDownloadsCell.self, forCellWithReuseIdentifier: downloadsCellId)
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        
        collectionView.backgroundColor = .white
        collectionView.anchor(top: menuView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = "Euforic"
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(handleSearch))
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [search, settings]
        navigationItem.rightBarButtonItems?.forEach({$0.tintColor = .darkGray})
    }
    
    fileprivate func statusBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let statusBarSize = window?.windowScene?.statusBarManager?.statusBarFrame else {return 0}
        return min(statusBarSize.width, statusBarSize.height)
    }
    
}

extension HomeController:UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: discoverCellId, for: indexPath) as! dummyDiscoverCell
            cell.discoverController.delegate = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: libraryCellId, for: indexPath) as! dummyLibraryCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: downloadsCellId, for: indexPath) as! dummyDownloadsCell
            return cell
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let statusBar = statusBarHeight()
        let topSafeArea = view.safeAreaInsets.top
        return .init(width: view.frame.width, height: view.frame.height - 60 - topSafeArea)
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
    
}

extension HomeController:MenuControllerDelegate, DiscoverControllerDelegate{
    
    func didTapPodcast(podcast: Podcast) {
        let podcastController = PodcastController()
        podcastController.podcast = podcast
        self.navigationController?.pushViewController(podcastController, animated: true)
    }
    
    func didTapMenuItem(_ indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func handleSearch(){
        let searchVC = SearchController()
        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true)
    }
    
}


class dummyDownloadsCell: UICollectionViewCell {
    
    let downloadsController = DownloadsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let downloadsView = downloadsController.view!
        addSubview(downloadsView)
        downloadsView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class dummyLibraryCell: UICollectionViewCell {
    
    let libraryController = LibraryController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let libraryView = libraryController.view!
        addSubview(libraryView)
        libraryView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dummyDiscoverCell: UICollectionViewCell {
    
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


