//
//  CommentBarView.swift
//  Instagram
//
//  Created by Michael Kan on 2023/09/30.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String)
}

final class CommentBarView: UIView {
    
    weak var delegate: CommentBarViewDelegate?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let field: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Comment"
        field.backgroundColor = .systemBackground
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(field)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapComment() {
        guard let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        delegate?.commentBarViewDidTapDone(self, withText: text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.sizeToFit()
        button.frame = CGRect(
            x: width-button.width-4-2,
            y: (height-button.height)/2,
            width: button.width+4,
            height: button.height
        )
        field.frame = CGRect(
            x: 2,
            y: 2,
            width: width-button.width-8,
            height: height-4
        )
    }
}
