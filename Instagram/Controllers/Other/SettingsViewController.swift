//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import SafariServices
import UIKit

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
    
    private var sections: [SettingsSection] = []
    
    // MARK: - Lifecycle
    
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
        sections.append(
            SettingsSection(title: "App", options: [
                SettingOption(
                    title: "Rate App",
                    image: UIImage(systemName: "star"),
                    color: .systemOrange
                ) {
                    guard let url = URL(string: "https://apps.apple.com/us/app/instagram/id389801252") else {
                        return
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                },
                SettingOption(
                    title: "Share App",
                    image: UIImage(systemName: "square.and.arrow.up"),
                    color: .systemBlue
                ) { [weak self] in
                    guard let url = URL(string: "https://apps.apple.com/us/app/instagram/id389801252") else {
                        return
                    }
                    DispatchQueue.main.async {
                        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                        self?.present(vc, animated: true)
                    }
                    
                }
                
            ])
        )
        
        sections.append(
            SettingsSection(title: "Information", options: [
                SettingOption(
                    title: "Terms of Service",
                    image: UIImage(systemName: "doc"),
                    color: .systemPink
                ) { [weak self] in
                    guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                    
                },
                SettingOption(
                    title: "Privacy Policy",
                    image: UIImage(systemName: "hand.raised"),
                    color: .systemPurple
                ) { [weak self] in
                    guard let url = URL(string: "https://help.instagram.com/155833707900388") else {
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                    
                },
                SettingOption(
                    title: "Get help",
                    image: UIImage(systemName: "message"),
                    color: .systemGreen
                ) { [weak self] in
                    guard let url = URL(string: "https://help.instagram.com/") else {
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                    
                }
                
            ])
        )
        
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
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.image
        cell.imageView?.tintColor = model.color
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
