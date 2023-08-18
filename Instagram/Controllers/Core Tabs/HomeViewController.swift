//
//  ViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //Register IGPostTableView
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // viewDidLayoutSubviews() is a method provided by UIViewController that is called after the view controller's view has laid out its subviews. It is part of the view controller's lifecycle and is invoked whenever the layout of the view and its subviews might have changed. This method is commonly used to perform additional layout adjustments or updates to the UI elements within the view.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNonAuth()
        tableView.delegate = self
        tableView.dataSource = self

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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
        return cell
    }
}
