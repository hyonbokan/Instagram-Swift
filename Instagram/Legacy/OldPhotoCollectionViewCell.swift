//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/19.
//
import SDWebImage
import UIKit

class OldPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "OldPhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    // Check the function of this override
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost){
//        let thumbnailURL = model.thumbnailImage
//        let task = URLSession.shared.dataTask(with: thumbnailURL, completionHandler: { data, _, _ in
//            photoImageView.image = UIImage(data: data!)
//        })
        let url = model.thumbnailImage
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    public func configure(debug imageName: String){
        photoImageView.image = UIImage(named: imageName)
    }
}
