//
//  SceneDelegate.swift
//  Taskflow
//
//  Created by Kanchan Bandesha on 3/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create your window and set its scene.
        let window = UIWindow(windowScene: windowScene)
        
        // Read saved theme from UserDefaults (defaults to light)
        let theme = UserDefaults.standard.string(forKey: "theme") ?? "light"
        window.overrideUserInterfaceStyle = (theme == "dark" ? .dark : .light)
        
        // Set your root view controller (make sure your storyboard has the correct identifier)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            window.rootViewController = tabBarController
        }
        
        // IMPORTANT: Assign the window and make it key and visible.
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyTheme),
            name: NSNotification.Name("ThemeDidChange"),
            object: nil
        )
    }

    // Called whenever theme changes
    @objc private func applyTheme() {
        let theme = UserDefaults.standard.string(forKey: "theme") ?? "light"
        window?.overrideUserInterfaceStyle = (theme == "dark") ? .dark : .light
    }

}
