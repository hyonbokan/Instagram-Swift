//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//

import UIKit

final class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var viewModels: [NotificationCellType] = []
    private var models: [IGNotification] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.indentifier)
        tableView.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.indentifier)
        tableView.register(CommentNotficationTableViewCell.self, forCellReuseIdentifier: CommentNotficationTableViewCell.indentifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    // lazy - instantiates only when it's called
    private lazy var noNotificationsView = NoNotificationsView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
//        spinner.startAnimating()
        view.addSubview(tableView)
//        view.addSubview(noNotificationsView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(noActivityLabel)
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
        
        let topSafeArea = view.safeAreaInsets.top
        let bottomSafeArea = view.safeAreaInsets.bottom
        let availableHeight = view.bounds.height - topSafeArea - bottomSafeArea
        
        
//        tableView.frame = view.bounds
        tableView.frame = CGRect(x: 0, y: topSafeArea, width: view.bounds.width, height: availableHeight)
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        
    }
    
    private func fetchNotifications() {
//        mockData()
        NotificationManager.shared.getNotifications { [weak self] models in
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
            }
        }
    }
    
    private func createViewModels() {
        models.forEach { model in
            guard let type = NotificationManager.IGType(rawValue: model.notificationType) else {
                return
            }
            let username = model.username
            guard let profilePictureUrl = URL(string: model.profilePictureUrl) else {
                return
            }
            // Derive
            
            switch type {
                case .like:
                    guard let postUrl = URL(string: model.postUrl ?? "") else { return }
                    viewModels.append(.like(viewModel: LikeNotificationCellViewModel(
                        username: username,
                        profilePictureUrl: profilePictureUrl,
                        postUrl: postUrl,
                        date: model.dateString
                        )
                    )
                )
                case .comment:
                    guard let postUrl = URL(string: model.postUrl ?? "") else { return }
                    viewModels.append(.comment(viewModel: CommentNotificationCellViewModel(
                        username: username,
                        profilePictureUrl: profilePictureUrl,
                        postUrl: postUrl,
                        date: model.dateString
                        )
                    )
                )
                case .follow:
                    guard let isFollowing = model.isFollowing else {
                        return
                    }
                    viewModels.append(.follow(viewModel: FollowNotificationCellViewModel(
                        username: username,
                        profilePictureUrl: profilePictureUrl,
                        isCurrentUserFollowing: isFollowing,
                        date: model.dateString
                        )
                    )
                )
            }
        }
        print(viewModels.count)
        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func mockData() {
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://avatars.githubusercontent.com/u/107212320?v=4"),
              let iconUrl = URL(string: "https://avatars.githubusercontent.com/u/107212320?v=4")
        else {
            return
        }
        viewModels = [
            .like(
                viewModel: LikeNotificationCellViewModel(
                    username: "annaKan",
                    profilePictureUrl: iconUrl,
                    postUrl: postUrl,
                    date: "September 10"
                )
            ),
            .comment(viewModel: CommentNotificationCellViewModel(
                username: "ryanKan",
                profilePictureUrl: iconUrl,
                postUrl: postUrl,
                date: "September 10"
                )
            ),
            .follow(viewModel: FollowNotificationCellViewModel(
                username: "gengisKhan",
                profilePictureUrl: iconUrl,
                isCurrentUserFollowing: true,
                date: "September 10"
                )
            )
        ]
        
        tableView.reloadData()
    }
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FollowNotificationTableViewCell.indentifier,
                for: indexPath
            ) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LikeNotificationTableViewCell.indentifier,
                for: indexPath
            ) as? LikeNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentNotficationTableViewCell.indentifier,
                for: indexPath
            ) as? CommentNotficationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        let username: String
        
        switch cellType {
        case .follow(let viewModel):
            username = viewModel.username
        case .like(let viewModel):
            username = viewModel.username
        case .comment(let viewModel):
            username = viewModel.username
        }
        
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            guard let user else {
                // Add show error alert
                return
            }
            // Update function to use username (below is the email)
            
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}

// MARK: - Actions

extension NotificationsViewController: LikeNotificationTableViewCellDelegate, FollowNotificationTableViewCellDelegate, CommentNotficationTableViewCellDelegate {
    
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell,
                                       didTapPostWith viewModel: LikeNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .comment, .follow:
                return false
            case .like(let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
//        print(index)
        openPost(with: index, username: viewModel.username)

    }
    
    
    func followNotificationTableViewCell(_ cell: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {
        
        let username = viewModel.username
        print("Requesting follow=\(isFollowing) for user=\(username)")
        DatabaseManager.shared.updateRelationship(
            state: isFollowing ? .follow : .unfollow,
            for: username) {
            [weak self] success in
                if !success {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "Error", message: "Unable to perform the request", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(ac, animated: true)
                    }
                }
        }
    }
    
    func commentNotficationTableViewCell(_ cell: CommentNotficationTableViewCell,
                                         didTapPostWith viewModel: CommentNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .like, .follow:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else {
            return
        }
        
        openPost(with: index, username: viewModel.username)
        
    }
    
    func openPost(with index: Int, username: String) {
        guard index < models.count else {
            return
        }
        let model = models[index]
        let username = username
        guard let postID = model.postId else {
            return
        }
        
        // Find post by id from target user
        DatabaseManager.shared.getPost(
            with: postID,
            from: username
        ) { [weak self] post in
            DispatchQueue.main.async {
                guard let post = post else {
                    let ac = UIAlertController(title: "Error", message: "Could not find the post", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(ac, animated: true)
                    return
                }
                let vc = PostViewController(post: post)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    
}
