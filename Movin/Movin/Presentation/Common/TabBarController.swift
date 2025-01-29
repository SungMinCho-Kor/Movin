//
//  TabBarController.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import UIKit

enum TabCase: String, CaseIterable {
    case cinema = "CINEMA"
    case upcoming = "UOCOMING"
    case profile = "PROFILE"
    
    var viewController: UIViewController {
        switch self {
        case .cinema:
            return CinemaViewController()
        case .upcoming:
            return UpcomingViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .cinema:
            return UIImage(systemName: "popcorn")
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
        view.backgroundColor = .movinBlack
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .movinBlack
        tabBar.tintColor = .movinPrimary
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
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = tabImage
        navigationController.tabBarItem.title = tabTitle
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .movinBlack
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        return navigationController
    }
}
