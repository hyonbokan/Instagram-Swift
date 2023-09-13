//
//  ProfileHeaderCountView.swift
//  Instagram
//
//  Created by dnlab on 2023/09/13.
//

import UIKit

class ProfileHeaderCountView: UIView {

    // Count buttons
    private let followerCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitle(("0\nFollower"), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followerCountButton)
        
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func addActions() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth: CGFloat = (width-10)/3
        followerCountButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: height/2)
        
    }

}
