//
//  NotificationLikeEventTableViewCell.swift
//  Instagram
//
//  Created by dnlab on 2023/08/22.
//
import SDWebImage //Pods dependency
import UIKit

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: UserNotification)
}

class NotificationLikeEventTableViewCell: UITableViewCell {

    static let indentifier = "NotificationLikeEventTableViewCell"
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "@hyonbo liked your photo"
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        selectionStyle = .none
    }
    
    @objc private func didTapPostButton() {
        print("Print inside the LikeEvent")
        guard let model = model else { return }
        print("guard let model = model passed")
        delegate?.didTapRelatedPostButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        
        switch model.type {
            // type is Enum: like, follow:
        case .like(let post):
            let thumbnail = post.thumbnailImage
            guard thumbnail.absoluteString.contains("google.com") else { return }
            postButton.sd_setImage(with: thumbnail, for: .normal, completed: nil)
        case .follow:
            break
        }
        
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        postButton.setBackgroundImage(nil, for: .normal)
//        label.text = nil
//        profileImageView.image = nil
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // photo, text, post button
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height-6, height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let size = contentView.height-4
        postButton.frame = CGRect(
            x: contentView.width-size-5,
            y: 2,
            width: size,
            height: size)
        
        label.frame = CGRect(
            x: profileImageView.right+5,
            y: 0,
            width: contentView.width-size-profileImageView.height-16,
            height: contentView.height
        )
    }
    
}
