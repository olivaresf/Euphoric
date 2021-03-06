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
                return DiscoverController.middleSection()
            }else{
                return DiscoverController.bottomSection()
            }
        }
        super.init(collectionViewLayout: layout)
    }
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label:UILabel = {
            let lbl = UILabel()
            lbl.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "Top Picks"
            lbl.textColor = UIColor(named: "primaryLabel")
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
			// Localization
            header.label.text = NSLocalizedString("Featured Podcasts", comment: "")
            return header
        default:
            header.label.text = "For you"
            return header
        }

    }
    
    static func bottomSection() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)))
        item.contentInsets.bottom = 12
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(135)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 18
        section.contentInsets.trailing = 18
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: kind, alignment: .topLeading)
        ]
        
        return section
    }
    
    static func middleSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.41),
                                               heightDimension: .absolute(340))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 22
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: kind, alignment: .topLeading)
        ]

        return section
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 18
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.60), heightDimension: .absolute(160)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 18
        section.contentInsets.bottom = 22
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: kind, alignment: .topLeading)
        ]
        
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerId = "headerId"
    var delegate:DiscoverControllerDelegate?
    
//    let categories:[Category] = Category.createCategories()
    var topPodcasts:[Podcast] = []
    var topPodcastsByCountry:[Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchPodcasts()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = UIColor(named: "blueBackground")
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
//        collectionView.register(TopCategoriesCell.self, forCellWithReuseIdentifier: TopCategoriesCell.reusableId)
        collectionView.register(TopPodcastCell.self, forCellWithReuseIdentifier: TopPodcastCell.reusableId)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reusableId)
        collectionView.contentInset.bottom = 78
    }
    
    func fetchPodcasts(){
    
        let dispatchGroup = DispatchGroup()
        
		// +1
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPodcasts(limit: 10) { (result) in
            switch result{
            case .failure(let err):
                print("Error fetching top podcasts:", err)
				
				// Read from Core Data
				self.topPodcasts = CoreDataManager.shared.read()
				
            case .success(let podcasts):
                self.topPodcasts = podcasts
				
				// Save the podcasts to Core Data
				CoreDataManager.shared.save(podcasts: podcasts)
            }
			
			dispatchGroup.leave()
        }
        
		// +1
        dispatchGroup.enter()
        NetworkManager.shared.fetchTopPodcastsByCountry(country: "AR", limit: 6) { (result) in
            switch result{
            case .failure(let err):
            print(err)
            case .success(let podcastByCountry):
                self.topPodcastsByCountry = podcastByCountry
            }
			
			dispatchGroup.leave()
        }
        
		// When the tasks are done (0), call the notify block.
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return topPodcasts.count
        default:
            return topPodcastsByCountry.count
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            delegate?.didTapPodcast(podcast: topPodcasts[indexPath.item])
        default:
            delegate?.didTapPodcast(podcast: topPodcastsByCountry[indexPath.item])
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
		
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPodcastCell.reusableId, for: indexPath) as! TopPodcastCell
            let podcast = topPodcasts[indexPath.item]
            cell.showImage.sd_setImage(with: URL(string: podcast.artworkUrl600 ?? ""))
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
