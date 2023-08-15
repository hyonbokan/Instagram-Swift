//
//  LoginViewController.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let usernameEmailField: UITextField = {
        return UITextField()
    }()
    
    private let passwordFIeld: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        return UIButton()
    }()
    
    private let termsButton: UIButton = {
        return UIButton()
    }()
    
    private let privacyButton: UIButton = {
        return UIButton()
    }()
    
    private let headerView: UIView = {
        return UIView()
    }()
    
    private let createAccountButton: UIView = {
        return UIView()
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()

        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        // assign frames
    }
    
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordFIeld)
        view.addSubview(loginButton)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        view.addSubview(headerView)
        view.addSubview(createAccountButton)

    }
    
    @objc private func didTapLoginButton() {}
    
    @objc private func didTapTermsButton() {}
    
    @objc private func didTapPrivacyButton() {}
    
    @objc private func didTapCreateAccountButton() {}

}
