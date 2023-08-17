//
//  ViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNonAuth()

    }
    private func handleNonAuth() {
        // Chekc auth status
        if Auth.auth().currentUser == nil {
            // Show log in
            print("Current user - nil")
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

