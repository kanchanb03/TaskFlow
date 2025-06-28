//
//  LoginViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        // Make sure to add "taskflow-logo" in your Assets.xcassets
        iv.image = UIImage(named: "taskflow-logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        // Optional styling
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        // Optional styling
        btn.backgroundColor = .systemGray
        btn.tintColor = .white
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = UIColor(red: 192/255, green: 216/255, blue: 233/255, alpha: 1)

        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)

        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([

            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),


            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            usernameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),


            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signInButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 15),
            signUpButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func signInTapped() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !username.isEmpty,
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else {
            showAlert(message: "Please enter both username and password.")
            return
        }

        let storedUsername = UserDefaults.standard.string(forKey: "username")?.lowercased()
        let storedPassword = UserDefaults.standard.string(forKey: "password")
        print("Attempting login. Entered username: \(username), stored username: \(storedUsername ?? "nil")")
        print("Entered password: \(password), stored password: \(storedPassword ?? "nil")")
        if username == storedUsername && password == storedPassword {
            // Login successful
            goToDashboard()
        } else {
            showAlert(message: "Invalid username or password.")
        }
    }

    @objc private func signUpTapped() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !username.isEmpty,
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else {
            showAlert(message: "Please enter both username and password.")
            return
        }

        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")

        print("Signed up with username: \(username), password: \(password)")
        goToDashboard()
    }

    private func goToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
