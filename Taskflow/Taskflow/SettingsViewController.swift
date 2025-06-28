//
//  SettingsViewController.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/15/25.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let themeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Light", "Dark"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        return sc
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Notification Time"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dynamicBackground
        title = "Settings"
        
        view.addSubview(themeLabel)
        view.addSubview(themeSegmentedControl)
        view.addSubview(notificationLabel)
        view.addSubview(timePicker)
        view.addSubview(resetPasswordButton)
        view.addSubview(logoutButton)
        
        setupConstraints()
        
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        requestNotificationPermission()
        loadSettings()
    }
        
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            themeLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            
            themeSegmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 10),
            themeSegmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            notificationLabel.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: 30),
            notificationLabel.leadingAnchor.constraint(equalTo: themeLabel.leadingAnchor),
            
            timePicker.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 10),
            timePicker.leadingAnchor.constraint(equalTo: themeLabel.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            resetPasswordButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            resetPasswordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 30),
            logoutButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }

    @objc private func themeChanged() {
        let newTheme = (themeSegmentedControl.selectedSegmentIndex == 0) ? "light" : "dark"
        UserDefaults.standard.set(newTheme, forKey: "theme")
        NotificationCenter.default.post(name: NSNotification.Name("ThemeDidChange"), object: nil)
    }
    
    @objc private func timePickerChanged() {
        scheduleDailyNotification(at: timePicker.date)
        UserDefaults.standard.set(timePicker.date, forKey: "notificationTime")
    }
    
    private func scheduleDailyNotification(at date: Date) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["taskReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget to check your tasks for today!"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: "taskReminder", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // Optionally handle the result here.
        }
    }
    
    @objc private func resetPasswordTapped() {
        let alert = UIAlertController(title: "Reset Password",
                                      message: "Enter your new password",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { textField in
            textField.placeholder = "Confirm New Password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            guard let newPassword = alert.textFields?[0].text, !newPassword.isEmpty,
                  let confirmPassword = alert.textFields?[1].text, !confirmPassword.isEmpty else {
                self.showAlert(message: "Please fill in both fields.")
                return
            }
            if newPassword != confirmPassword {
                self.showAlert(message: "Passwords do not match.")
            } else {
                UserDefaults.standard.set(newPassword, forKey: "password")
                self.showAlert(message: "Password reset successfully.")
            }
        }))
        present(alert, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Settings", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadSettings() {
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            themeSegmentedControl.selectedSegmentIndex = (theme == "light") ? 0 : 1
        }
        if let savedDate = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            timePicker.date = savedDate
        }
    }
    
    @objc private func logoutTapped() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let navController = UINavigationController(rootViewController: loginVC)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
