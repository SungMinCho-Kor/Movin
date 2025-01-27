//
//  TabBarController.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import UIKit

enum TabCase {
    case cinema
    case upcoming
    case profile
}

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movinBlack
        
        print(Environment.accessToken.value)
        print(Environment.baseURL.value)
        print(Environment.imageBaseURL.value)
    }
}
