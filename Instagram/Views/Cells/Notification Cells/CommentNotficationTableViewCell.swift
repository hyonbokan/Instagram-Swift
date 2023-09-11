//
//  CommentNotficationTableViewCell.swift
//  Instagram
//
//  Created by dnlab on 2023/09/08.
//

import UIKit

protocol CommentNotficationTableViewCellDelegate: AnyObject {
    func commentNotficationTableViewCell(_ cell: CommentNotficationTableViewCell,
                                         didTapPostWith viewModel: CommentNotificationCellViewModel)
}

class CommentNotficationTableViewCell: UITableViewCell {
    
    static let indentifier = "CommentNotficationTableViewCell"
    
    weak var delegate: CommentNotficationTableViewCellDelegate?
    
    private var viewModel: CommentNotificationCellViewModel?
    
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
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    
// MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(postImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        postImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPost() {
        guard let vm = viewModel else { return }
        delegate?.commentNotficationTableViewCell(self, didTapPostWith: vm)
    }
    
    // prepareForReuse - in testing
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        profilePictureImageView.image = nil
        postImageView.image = nil
        dateLabel.text = nil
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
        dateLabel.sizeToFit()
        
        label.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: 0,
            width: labelSize.width,
            height: contentView.height-dateLabel.height-2
        )
        
        
        dateLabel.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: contentView.height-dateLabel.height-2,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }
    
    public func configure(with viewModel: CommentNotificationCellViewModel) {
        self.viewModel = viewModel
        profilePictureImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        postImageView.sd_setImage(with: viewModel.postUrl, completed: nil)
        label.text = viewModel.username + " commented on your post"
        dateLabel.text = viewModel.date
    }
    
}
