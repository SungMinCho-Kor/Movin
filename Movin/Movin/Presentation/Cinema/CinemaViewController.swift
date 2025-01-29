//
//  CinemaViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class CinemaViewController: BaseViewController {
    private let profileView = CinemaProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [
            profileView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.18)
        }
        
    }
    
    override func configureViews() {
        navigationItem.title = "Movin"
        
        profileView.profileInfoButton.addTarget(
            self,
            action: #selector(profileInfoButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func profileInfoButtonTapped() {
        print("Profile Edit")
    }
}
