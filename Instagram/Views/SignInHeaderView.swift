//
//  SignInHeaderView.swift
//  Instagram
//
//  Created by dnlab on 2023/08/28.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_text")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var gradientLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = layer.bounds
        
        imageView.frame = CGRect(
            x: width/4,
            y: 20,
            width: width/2,
            height: height-40)
    }
}
