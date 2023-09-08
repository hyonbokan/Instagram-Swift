/*
 Section
 - Header model
 Section
 - Post Cell model
 Section
 - Action Buttons Cell model
 Section
 - n Number of general models for comments
 
 */

import UIKit
/// States of a rendered cell
enum PostRenderType {
    case header(provider: UserOld)
    case primaryContent(provider: UserPost) //post
    case actions(prvider: String) // like, comment, share
    case comments(comments: [PostComment])
}
/// Model of rendered posts
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    private let post: Post
    
    // MARK: - Init
    
    // UserPost optional is for the test
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Post"
        
    }
    
   
}
