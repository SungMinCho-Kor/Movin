//
//  SceneDelegate.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setAppearance()
        window = UIWindow(windowScene: scene)
        
        let navigationController = UserDefaultsManager.shared.isOnboardingDone ? TabBarController() : BasicNavigationController(rootViewController: OnboardingViewController())
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setAppearance() {
        UITextField.appearance().textColor = .movinLabel
    }
}
