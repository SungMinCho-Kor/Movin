//
//  BaseViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

class BaseViewController: UIViewController, ViewConfiguration {
    init() {
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
    }
}
