//
//  StoryHeaderView.swift
//  Instagram
//
//  Created by dnlab on 2023/10/04.
//

import UIKit

class StoryHeaderView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static let identifier = "StoryHeaderView"
    
    private var viewModels: [Story] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
//        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo_text")
        logoImage.contentMode = .scaleAspectFit
//        logoImage.backgroundColor = .blue
        return logoImage
    }()
    
    private let messageButton: UIButton = {
        let messageButton = UIButton()
        messageButton.tintColor = .label
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        messageButton.setImage(image, for: .normal)
//        messageButton.backgroundColor = .orange
        return messageButton
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .red
        addSubview(collectionView)
        addSubview(logoImage)
        addSubview(messageButton)
        messageButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapMessage() {
        print("message tapped")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImage.frame = CGRect(
            x: 0,
            y: 0,
            width: width/3,
            height: height/4
        )
        messageButton.frame = CGRect(
            x: width-50,
            y: 0,
            width: 50,
            height: height/4
        )
        
        collectionView.frame = CGRect(
            x: 0,
            y: logoImage.bottom,
            width: width,
            height: height*0.7
        )
    }
    

    func configure(with viewModel: StoriesViewModel) {
        self.viewModels = viewModel.stories
    }
    
    // CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCollectionViewCell.identifier,
            for: indexPath
        ) as? StoryCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.height, height: collectionView.height)
    }
}
