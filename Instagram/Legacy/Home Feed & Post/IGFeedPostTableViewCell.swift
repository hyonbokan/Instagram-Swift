//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by dnlab on 2023/08/18.
//
import AVFoundation
import SDWebImage
import UIKit

/// Cell for primary post content
final class IGFeedPostTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    
    private var playerLayer = AVPlayerLayer()
    
    //override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?): This is the designated initializer for the UITableViewCell subclass. It overrides the initializer from the superclass (UITableViewCell) to provide custom initialization behavior. The parameters style and reuseIdentifier are passed to the superclass initializer using the super keyword.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.addSublayer(playerLayer) // add playerLayer first!
        contentView.addSubview(postImageView)
        
    }
    // required init?(coder: NSCoder): This initializer is required when creating instances of the class from a storyboard or nib file. It is marked as required because it is required for the superclass (UITableViewCell). This initializer is not implemented (fatalError) since this cell is not intended to be created from a storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        postImageView.image = UIImage(named: "test")
        
        return
        switch post.postType {
        case .photo:
            // load image
            postImageView.sd_setImage(with: post.postURL, completed: nil)
        case .video:
            // load and play video
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
            
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }

}
