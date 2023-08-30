//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import SafariServices
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellModel(title: "Invite Friends") { [weak self] in
                self?.didTapInviteFriends()
            },
            SettingCellModel(title: "Save Original Posts") { [weak self] in
                self?.didTapSaveOriginalPosts()
            }
        ])
        
        
        
        data.append([
            SettingCellModel(title: "Terms of Service") { [weak self] in
                self?.openURL(type: .terms)
            },
            
            SettingCellModel(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)
            },
            
            SettingCellModel(title: "Help / Feedback") { [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            SettingCellModel(title: "Sign Out") { [weak self] in
                self?.didTapSignOut()
            }
        ])
    }
    enum SettingURLType {
        case terms, privacy, help
    }
    
    private func didTapEditProfile() {
        // Show share sheet to invite friends
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {

    }
    
    private func didTapSaveOriginalPosts() {
        
    }
    
    private func openURL(type: SettingURLType) {
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/155833707900388"
        case .help: urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
        
    }
    
    private func didTapSignOut() {
        let actionSheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        self?.didTapClose()
                    }
                }
            }
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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Handle cell selection
        let model = data[indexPath.section][indexPath.row]
        model.handler()
    }
}
