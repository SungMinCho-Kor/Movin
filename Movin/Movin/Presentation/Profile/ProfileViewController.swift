//
//  ProfileViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class ProfileViewController: BaseViewController {
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    override func configureViews() {
        profileView.profileInfoButton.addTarget(
            self,
            action: #selector(profileInfoButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func profileInfoButtonTapped() {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.delegate = self
        present(
            BasicNavigationController(rootViewController: profileEditViewController),
            animated: true
        )
    }
}

extension ProfileViewController: ProfileSaveDelegate {
    func reloadProfile() {
        profileView.refreshView()
    }
}
