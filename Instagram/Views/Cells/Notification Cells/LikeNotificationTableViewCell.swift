//
//  NotificationLikeEventTableViewCell.swift
//  Instagram
//
//  Created by dnlab on 2023/08/22.
//
import SDWebImage //Pods dependency
import UIKit

protocol LikeNotificationTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: UserNotification)
}

class LikeNotificationTableViewCell: UITableViewCell {

    static let indentifier = "LikeNotificationTableViewCell"
    
    weak var delegate: LikeNotificationTableViewCellDelegate?
    
    
//    weak var delegate: CommentNotficationTableViewCellDelegate?
    
    private var viewModel: LikeNotificationCellViewModel?
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    
// MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(label)
        selectionStyle = .none
    }
    
    @objc private func didTapFollowButton() {

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // prepareForReuse - in testing
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height/1.5
        
        profilePictureImageView.frame = CGRect(
            x: 10,
            y: (contentView.height-imageSize)/2,
            width: imageSize,
            height: imageSize
        )
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.height/2
        
        let postSize: CGFloat = contentView.height - 6
        postImageView.frame = CGRect(
            x: contentView.width-postSize-10, y: 3,
            width: postSize,
            height: postSize
        )
        
        
        let labelSize = label.sizeThatFits(
            CGSize(
            width: contentView.width-profilePictureImageView.right-25-postSize,
            height: contentView.height
            )
        )
        label.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: 0,
            width: labelSize.width,
            height: contentView.height
        )
    }
    
    public func configure(with viewModel: LikeNotificationCellViewModel) {
        profilePictureImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
        label.text = viewModel.username + " liked on your post"
    }
}
