//
//  LibraryController.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import SwiftUI

let favoritedNotificationKey = "co.diegois.favorited"

class LibraryController: UICollectionViewController {
    
    let favoritedNoti = Notification.Name(rawValue: favoritedNotificationKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) ->
            NSCollectionLayoutSection? in

            if sectionNumber == 0{
                return LibraryController.myLibrarySection()
            }else{
                return LibraryController.recentlyPlayedSection()
            }

        }
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func recentlyPlayedSection() -> NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)))
        item.contentInsets.bottom = 12
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 18
        section.contentInsets.trailing = 18
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), elementKind: kind, alignment: .topLeading)
        ]
        
        return section
    }
    
    static func myLibrarySection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 12
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.40), heightDimension: .absolute(140)), subitems: [item])
    
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 18
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), elementKind: kind, alignment: .topLeading)
        ]
        return section
    }
    
    var favoritedPodcasts = UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(TopPodcastCell.self, forCellWithReuseIdentifier: TopPodcastCell.reusableId)
        createObservers()
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: favoritedNoti, object: nil)
    }
    
    @objc func reloadData(){
        favoritedPodcasts = UserDefaults.standard.savedPodcasts()
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! CompositionalHeader
        
        switch indexPath.section {
        case 0:
            cell.label.text = "Favorites"
        default:
            cell.label.text = "Recently Played"
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPodcastCell.reusableId, for: indexPath) as! TopPodcastCell
            cell.showImage.sd_setImage(with: URL(string: favoritedPodcasts[indexPath.item].artworkUrl600 ?? ""))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
            return cell
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.favoritedPodcasts.count
        default:
            return 10
        }
    }
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label:UILabel = {
            let lbl = UILabel()
            lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "Top Picks"
            lbl.textColor = .normalDark
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
    }
    
}

struct LibraryView:UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = LibraryController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct LibraryController_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .edgesIgnoringSafeArea(.all)
    }
}
