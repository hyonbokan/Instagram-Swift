//
//  ViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //Register IGPostTableView
        tableView.register(IGFeedPostTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        createMockModels()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createMockModels() {
        let user = User(username: "@hyonbo",
                        name: (first: "Hyonbo", last: "Kan"),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        
        let post = UserPost(
            identifier: "",
            postType: .photo,
            thumbnailImage: URL(string: "https://www.google.com")!,
            postURL: URL(string: "https://www.google.com")!,
            caption: nil,
            likeCount: [],
            comment: [],
            createdDate: Date(),
            taggedUsers: [],
            owner: user)
        
        var comments = [PostComment]()
        for x in 0..<2{
            comments.append(PostComment(
                indetifier: "\(x)",
                username: "@john",
                text: "HomeFeed Post",
                createded: Date(),
                likes: []))
        }
        
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(
                header: PostRenderViewModel(renderType: .header(provider: user)),
                post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                actions: PostRenderViewModel(renderType: .actions(prvider: "")),
                comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNonAuth()
    }
    
    
    private func handleNonAuth() {
        // Chekc auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            print("Current user - nil")
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? x/4 : (x - (x % 4)) / 4
            model = feedRenderModels[position]
        }
       
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            return 1
            
        } else if subSection == 1{
            // post
            return 1
            
        } else if subSection == 2{
            // action
            return 1
            
        } else if subSection == 3{
            // comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            // Double check the logic of fitting the model
            let position = x % 4 == 0 ? x/4 : (x - (x % 4)) / 4
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(
                        withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                        for: indexPath) as! IGFeedPostHeaderTableViewCell
                
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        } else if subSection == 1{
            // post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(
                        withIdentifier: IGFeedPostTableViewCell.identifier,
                        for: indexPath) as! IGFeedPostTableViewCell
                
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        } else if subSection == 2{
            // action
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(
                        withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                        for: indexPath) as! IGFeedPostActionsTableViewCell
                
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
        } else if subSection == 3{
            // comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            // Header
            return 70
        } else if subSection == 1 {
            // Post
            return tableView.width
        } else if subSection == 2 {
            // Actions
            return 60
        } else if subSection == 3 {
            // Comment row
            return 50
        } else {
            return 0
        }
    }
    
    // Below add spacing between feeds
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}

extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Repost Post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
}

extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("Like")
    }
    
    func didTapCommentButton() {
        print("Comment")
    }
    
    func didTapSendButton() {
        print("Send")
    }
}
