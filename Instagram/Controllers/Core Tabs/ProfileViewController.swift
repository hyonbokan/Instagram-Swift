//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/30.
//

import UIKit

class ProfileViewController: UIViewController {

    private let user: User
    
    private var headerViewModel: ProfileHeaderViewModel?
    
    private var isCurrentUser: Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    private var collectionView: UICollectionView?
    
    // MARK: - Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureCollectionView()
        fetchProfileInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchProfileInfo() {
//        headerViewModel = ProfileHeaderViewModel(
//            profilePictureUrl: nil,
//            followerCount: 200,
//            followingCount: 130,
//            postCount: 30,
//            buttonType: isCurrentUser ? .edit : .follow(isFollowing: true),
//            name: "Name: Test",
//            bio: "Test profile"
//        )
        var profilePictureUrl: URL?
        var buttonType: ProfileButtonType = .edit
        var followers = 0
        var following = 0
        var posts = 0
        var name: String?
        var bio: String?
        
        let group = DispatchGroup()
        
        // Counts (total: 3)
        group.enter()
        DatabaseManager.shared.getUserCounts(username: user.username) { result in
            defer {
                group.leave()
            }
            posts = result.posts
            followers = result.followers
            following = result.following
        }
        
        // Bio, name
        DatabaseManager.shared.getUserInfo(username: user.username) { userInfo in
            name = userInfo?.name
            bio = userInfo?.bio
        }
        
        // Profile pic url
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            profilePictureUrl = url
        }
        
        // if profile is not for current user, get follow state
        if !isCurrentUser {
            // Have the follow state
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                buttonType = .follow(isFollowing: isFollowing)
            }
        }
        
        group.notify(queue: .main) {
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureUrl,
                followerCount: followers,
                followingCount: following,
                postCount: posts,
                buttonType: buttonType,
                name: name,
                bio: bio
            )
            self.collectionView?.reloadData()
        }
    }
    
    func configureNavBar() {
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        }
    }
    
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }

}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: UIImage(named: "test"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
            ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        // instead of creating another delegate - ProfileHeaderCollectionReusableView, have the container public
        if let viewModel = headerViewModel {
            headerView.configure(with: viewModel)
            headerView.countContainerView.delegate = self
        }
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let post =
//        let vc = PostViewController(post: post)
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: ProfileHeaderCountViewDelegate {
    func profileHeaderCountViewDidTapFollowers(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollowing(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollowPosts(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollowEditProfile(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapFollow(_ containerView: ProfileHeaderCountView) {
        
    }
    
    func profileHeaderCountViewDidTapUnfollow(_ containerView: ProfileHeaderCountView) {
        
    }
    
    
}

extension ProfileViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(0.33)
                    ),
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(0.66)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                
                return section
            })
        )
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // Don't foreget to assign this collectionView to the gloabal collectionView
        self.collectionView = collectionView
    }
}
