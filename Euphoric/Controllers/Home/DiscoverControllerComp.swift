//
//  DiscoverControllerComp.swift
//  Euphoric
//
//  Created by Diego Oruna on 18/08/20.
//

import SwiftUI

protocol DiscoverControllerDelegate {
    func didTapPodcast(podcast:Podcast)
}


class DiscoverController: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) ->
            NSCollectionLayoutSection? in
            
            if sectionNumber == 0{
                return DiscoverController.topSection()
            }else if sectionNumber == 1{
                return DiscoverController.middleSection()
            }else {
                return DiscoverController.bottomSection()
            }
        }
        super.init(collectionViewLayout: layout)
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        
        switch indexPath.section {
        case 0:
            header.label.text = "Top Categories"
            return header
        case 1:
            header.label.text = "Featured Podcasts"
            return header
        default:
            header.label.text = "Reccomended for you"
            return header
        }

        
    }
    
    static func bottomSection() -> NSCollectionLayoutSection{
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
    
    static func middleSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.45))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45),
                                               heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 18
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), elementKind: kind, alignment: .topLeading)
        ]

        return section
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 18
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75), heightDimension: .absolute(200)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 18
        section.contentInsets.bottom = 18
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), elementKind: kind, alignment: .topLeading)
        ]
        
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerId = "headerId"
    var delegate:DiscoverControllerDelegate?
    
    let categories:[Category] = Category.createCategories()
    var topPodcasts:[Podcast] = []
    var topPodcastsByCountry:[Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPodcasts()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Diego"
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(TopCategoriesCell.self, forCellWithReuseIdentifier: TopCategoriesCell.reusableId)
        collectionView.register(TopPodcastCell.self, forCellWithReuseIdentifier: TopPodcastCell.reusableId)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reusableId)
    }
    
    func fetchPodcasts(){
    
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPodcasts(limit: 10) { (result) in
            switch result{
            case .failure(let err):
                print(err)
            case .success(let podcasts):
                self.topPodcasts = podcasts
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPodcastsByCountry(country: "AR", limit: 6) { (result) in
            switch result{
            case .failure(let err):
            print(err)
            case .success(let podcastByCountry):
                self.topPodcastsByCountry = podcastByCountry
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return categories.count
        case 1:
            return topPodcasts.count
        default:
            return topPodcastsByCountry.count
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            print("Header")
        case 1:
            delegate?.didTapPodcast(podcast: topPodcasts[indexPath.item])
        default:
            delegate?.didTapPodcast(podcast: topPodcastsByCountry[indexPath.item])
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategoriesCell.reusableId, for: indexPath) as! TopCategoriesCell
            cell.category = categories[indexPath.item]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPodcastCell.reusableId, for: indexPath) as! TopPodcastCell
            let podcast = topPodcasts[indexPath.item]
            cell.showImage.sd_setImage(with: URL(string: podcast.artworkUrl600))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reusableId, for: indexPath) as! SearchCell
            cell.podcast = topPodcastsByCountry[indexPath.item]
            return cell
        }
        
        
    }
    
}

struct DiscoverView:UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = DiscoverController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct DiscoverControllerComp_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .edgesIgnoringSafeArea(.all)
    }
}
