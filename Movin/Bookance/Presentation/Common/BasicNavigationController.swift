//
//  BasicNavigationController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

final class BasicNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar() {
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [ //TODO: 안 된다
            .foregroundColor: UIColor.black
        ]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationBar.scrollEdgeAppearance = appearance
    }
}
