//
//  SignInViewController.swift
//  Instagram
//
//  Created by dnlab on 2023/08/28.
//
import SafariServices
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // Subviews
    
    private let profilePictureImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    // Custom IGTextField
    private let usernameField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let emailField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let passwordField: IGTextField = {
        let field = IGTextField()
        field.placeholder = "Create Password"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()

    
    // MARK: = Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        addSubviews()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        addButtonActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 90
        
        profilePictureImageView.frame = CGRect(
            x: (view.width - imageSize)/2,
            y: view.safeAreaInsets.top+15,
            width: imageSize,
            height: imageSize
        )
        
        usernameField.frame = CGRect(
            x: 25,
            y: profilePictureImageView.bottom+20,
            width: view.width-50,
            height: 50
        )
        
        
        emailField.frame = CGRect(
            x: 25,
            y: usernameField.bottom+20,
            width: view.width-50,
            height: 50
        )
        passwordField.frame = CGRect(
            x: 25,
            y: emailField.bottom+10,
            width: view.width-50,
            height: 50
        )
        signUpButton.frame = CGRect(
            x: 35,
            y: passwordField.bottom+20,
            width: view.width-70,
            height: 50
        )
        
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 100,
            width: view.width - 20,
            height: 40
        )
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 50,
            width: view.width - 20,
            height: 40
        )
        
    }
    
    private func addSubviews() {
        view.addSubview(profilePictureImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func addButtonActions() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    // MARK: Actions
    @objc func didTapSignUp() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard
            let email = emailField.text,
            let password = passwordField.text,
            !email.trimmingCharacters(in: .whitespaces).isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
            return
        }
        
        // Sign in with authManager
    }
    
    
    @objc func didTapTerms() {
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://help.instagram.com/155833707900388") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    // MARK: Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            didTapSignUp()
        }
        return true
    }
}
