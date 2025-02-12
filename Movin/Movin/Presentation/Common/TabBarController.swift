//
//  TabBarController.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import UIKit

enum TabCase: String, CaseIterable {
    case main = "MAIN"
    case upcoming = "UOCOMING"
    case profile = "PROFILE"
    
    var viewController: UIViewController {
        switch self {
        case .main:
            return CinemaViewController()
        case .upcoming:
            return UpcomingViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "house")
        case .upcoming:
            return UIImage(systemName: "film.stack")
        case .profile:
            return UIImage(systemName: "person.crop.circle")
        }
    }
}

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTabs()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
    }
    
    private func configureTabs() {
        let controllers = TabCase.allCases.map {
            return createNavigationController(
                viewController: $0.viewController,
                tabTitle: $0.rawValue,
                tabImage: $0.tabImage
            )
        }
        setViewControllers(
            controllers,
            animated: false
        )
    }
    
    private func createNavigationController(
        viewController: UIViewController,
        tabTitle: String?,
        tabImage: UIImage?
    ) -> BasicNavigationController {
        let navigationController = BasicNavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = tabImage
        navigationController.tabBarItem.title = tabTitle
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        appearance.shadowColor = nil
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        return navigationController
    }
}
