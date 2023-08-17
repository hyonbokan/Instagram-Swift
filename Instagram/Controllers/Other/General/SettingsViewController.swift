//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//

import UIKit
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}
/// View Controller to show user settings
final class SettingsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "cell"
        )
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        let section = [
            SettingCellModel(title: "Log Out") { [weak self] in
                self?.didTapLogOut()
            }
        ]
        data.append(section)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.logOut(completion: { success in
                if success {
                    // present log in
                    DispatchQueue.main.async {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                } else {
                    // error
                    fatalError("Could not log out user.")
                }
            })
        }))
        // popverPressentationControllect for iPad
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)

    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Handle cell selection
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
}
