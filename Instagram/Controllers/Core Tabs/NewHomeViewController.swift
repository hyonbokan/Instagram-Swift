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
    
    private var observer: NSObjectProtocol?
    
    private var allPosts: [(post: Post, owner: String)] = []
    
//    private var allStories: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchPosts()
//        fetchStories()
        
        observer = NotificationCenter.default.addObserver(
            forName: .didPostNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchPosts()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    @objc private func didTapMessage() {
        
    }
    
    private func fetchPosts() {
        // test data
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let userGroup = DispatchGroup()
        userGroup.enter()
        
        var allPosts: [(post: Post, owner: String)] = []
        
        DatabaseManager.shared.following(for: username) { usernames in
            defer {
                userGroup.leave()
            }
            let users = usernames + [username]
            print("\nUsers: \(users)\n")
            for current in users  {
                userGroup.enter()
                DatabaseManager.shared.posts(for: current) { result in
                    DispatchQueue.main.async {
                        defer {
                            userGroup.leave()
                        }
                        
                        switch result {
                        case .success(let posts):
                            print("\n\(current) Post count: \(posts.count)\n")
                            allPosts.append(contentsOf: posts.compactMap({
                                (post: $0, owner: current)
                            }))
                            
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
            }
        }
        
        userGroup.notify(queue: .main) {
            let group = DispatchGroup()
            self.allPosts = allPosts
            allPosts.forEach { model in
                group.enter()
                self.createViewModel(
                    model: model.post,
                    username: model.owner,
                    completion: { success in
                        defer {
                            group.leave()
                        }
                        if !success {
                            print("failed to create VM")
                        }
                    }
                )
            }
            group.notify(queue: .main) {
                self.sortData()
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func sortData() {
        allPosts = allPosts.sorted(by: { first, second in
            let date1 = first.post.date
            let date2 = second.post.date
            return date1 > date2
        })
        
        viewModels = viewModels.sorted(by: { first, second in
            var date1: Date?
            var date2: Date?
            first.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date1 = vm.date
                default:
                    break
                }
            }
            second.forEach { type in
                switch type {
                case .timestamp(let vm):
                    date2 = vm.date
                default:
                    break
                }
            }

            if let date1 = date1, let date2 = date2 {
                return date1 > date2
            }

            return false
        })
    }
    
    private func fetchStories() {
        
    }
    
    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let postUrl = URL(string: model.postUrlString),
                  let profilePhotoUrl = profilePictureURL else {
                return
            }
            
            let isLiked = model.likers.contains(currentUsername)
            
            let postData: [HomeFeedCellType] = [
                .poster(viewModel: PosterCollectionViewCellViewModel(
                    username: username,
                    profilePictureURL: profilePhotoUrl
                    )
                ),
                .post(viewModel: PostCollectionViewCellViewModel(
                    postURL: postUrl
                    )
                ),
                .actions(viewModel: PostActionsCollectionViewCellViewModel(
                    isLiked: isLiked
                    )
                ),
                .likeCount(viewModel: PostLikesCollectionViewCellViewModel(
                    likers: model.likers
                    )
                ),
                .caption(viewModel: PostCaptionCollectionViewCellViewModel(
                    username: username,
                    caption: model.caption
                    )
                ),
                .timestamp(viewModel: PostDateTimeCollectionViewCellViewModel(
                    date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                    )
                )
            ]
            self?.viewModels.append(postData)
            completion(true)
        }
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
            // Stories UI section
            if index == 0 {
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(0.4)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
            }

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
        // Stories header. Dequeue it!
        collectionView.register(
            StoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoryHeaderView.identifier
        )
        
        self.collectionView = collectionView
    }

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
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostCollectionViewCell else {
                 fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostActionsCollectionViewCell else {
                 fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostLikesCollectionViewCell else {
                 fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
            
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostCaptionCollectionViewCell else {
                 fatalError()
             }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
            
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifier,
                 for: indexPath
             ) as? PostDateTimeCollectionViewCell else {
                 fatalError()
             }
             cell.configure(with: viewModel)
             return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: StoryHeaderView.identifier,
                for: indexPath
              ) as? StoryHeaderView else {
            return UICollectionReusableView()
        }
        let viewModel = StoriesViewModel(stories: [
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
            Story(username: "story1", image: UIImage(named: "test")),
        ])
        headerView.configure(with: viewModel)
        return headerView
    }
}

extension NewHomeViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let section = self?.viewModels[index] ?? []
                section.forEach { cellType in
                    switch cellType {
                    case .post(let viewModel):
                        let vc = UIActivityViewController(
                            activityItems: ["Sharing from Instagram", viewModel.postURL],
                            applicationActivities: [])
                        self?.present(vc, animated: true)
                    default:
                        break
                    }
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            AnalyticsManager.shared.logFeedInteraction(.reported)
            let ac = UIAlertController(title: "Please input the issue you want to report", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let action = UIAlertAction(title: "Send", style: .default)
            ac.addAction(action)
            self.present(ac, animated: true)
        }))
        
        present(sheet, animated: true)
    }
    
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
        let tuple = allPosts[index]
        let vc = ProfileViewController(user: User(username: tuple.owner, email: tuple.owner))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewHomeViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.doubleTapToLike)
        let tuple = allPosts[index]
        DatabaseManager.shared.updateLike(
            state: .like,
            postID: tuple.post.id,
            owner: tuple.owner
        ) { success in
            guard success else {
                return
            }
            print("Failed to like")
        }
    }
}

extension NewHomeViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.like)
        HapticManager.shared.vibrateForSelection()
        // call DB to update like state
        let tuple = allPosts[index]
        DatabaseManager.shared.updateLike(
            state: isLiked ? .like : .unlike,
            postID: tuple.post.id,
            owner: tuple.owner
        ) { success in
            guard success else {
                return
            }
            print("Failed to like")
        }
    }
    
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.comment)
        print("All posts: \(allPosts)")
        let tuple = allPosts[index]
//        print("\npost tuple: \(tuple)\n")
        HapticManager.shared.vibrateForSelection()
        let vc = PostViewController(post: tuple.post, owner: tuple.owner)
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        AnalyticsManager.shared.logFeedInteraction(.share)
        let section = viewModels[index]
        section.forEach { cellType in
            switch cellType {
            case .post(let viewModel):
                let vc = UIActivityViewController(
                    activityItems: ["Sharing from Instagram", viewModel.postURL],
                    applicationActivities: [])
                present(vc, animated: true)
            default:
                break
            }
        }
    }
}

extension NewHomeViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
        HapticManager.shared.vibrateForSelection()
        let vc = ListViewController(type: .likers(usernames: allPosts[index].post.likers))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewHomeViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell) {
        print("Caption Tapped")
    }
}
