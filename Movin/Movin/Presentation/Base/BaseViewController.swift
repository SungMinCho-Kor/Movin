//
//  BaseViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

class BaseViewController: UIViewController, ViewConfiguration {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBase()
        configureHierarchy()
        configureLayout()
        configureViews()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureViews() { }
    
    private func configureBase() {
        view.backgroundColor = .movinBlack
    }
}
