//
//  NewHomeViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/31.
//

import UIKit

class NewHomeViewController: UIViewController {

    private var collectionView: UICollectionView?
    
    private var viewModels = [[HomeFeedCellType]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchPosts()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchPosts() {
        // test data
        let postData: [HomeFeedCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(
                username: "hyonbo",
                profilePictureURL: URL(
                    string: "https://github.githubassets.com/images/modules/profile/achievements/pull-shark-default.png")!
                )
            ),
            .post(viewModel: PostCollectionViewCellViewModel(
                postURL: URL(
                    string: "https://github.githubassets.com/images/modules/profile/achievements/pull-shark-default.png")!
                )
            ),
            .actions(viewModel: PostActionsCollectionViewCellViewModel(
                isLiked: true
                )
            ),
            .likeCount(viewModel: PostLikesCollectionViewCellViewModel(
                likers: ["stevejobs"]
                )
            ),
            .caption(viewModel: PostCaptionCollectionViewCellViewModel(
                username: "hyonbo",
                caption: "Caption test"
                )
            ),
            .timestamp(viewModel: PostDateTimeCollectionViewCellViewModel(
                date: Date()
                )
            )
        ]
        
        viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    private func configureCollectionView() {
        let sectionHeight: CGFloat = 240 + view.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            
            // Item - check the dimentions of the items
            let posterItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
            )
            
            let postItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                )
            )
            
            let actionsItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )
            
            let likeCountItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )

            let captionItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
            )
            
            let timestampItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                )
            )
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(sectionHeight)
                ),
                subitems: [
                    posterItem,
                    postItem,
                    actionsItem,
                    likeCountItem,
                    captionItem,
                    timestampItem
                ]
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            // adding space between sections
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)
            return section
        }))
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifier
        )
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier
        )
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifier
        )
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifier
        )
        self.collectionView = collectionView
    }
    
    let colors: [UIColor] = [
        .red,
        .green,
        .blue,
        .orange,
        .cyan,
        .brown
    ]

}

extension NewHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType {
        
        case .poster(let viewModel):
           guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             return cell
            
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostActionsCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
            
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostLikesCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
            
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostCaptionCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
            
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostDateTimeCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             cell.contentView.backgroundColor = colors[indexPath.row]
             return cell
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.contentView.backgroundColor = colors.randomElement()
//        return cell
    }
    
    
}
