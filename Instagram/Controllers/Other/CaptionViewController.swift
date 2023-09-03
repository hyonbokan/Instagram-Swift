//
//  CaptionViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/09/03.
//

import UIKit

class CaptionViewController: UIViewController {
    
    private let image: UIImage
    
    init(image: UIImage){
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    


}
