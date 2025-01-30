//
//  CinemaViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class CinemaViewController: BaseViewController {
    private let profileView = CinemaProfileView()
    private let recentSearchView = RecentSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.refreshView()
        recentSearchView.refreshView()
    }
    
    override func configureHierarchy() {
        [
            profileView,
            recentSearchView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.18)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigationItem.title = "Movin"
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(
                    image: UIImage(systemName: "magnifyingglass"),
                    style: .plain,
                    target: self,
                    action: #selector(searchButtonTapped)
                )
            ],
            animated: true
        )
        
        profileView.profileInfoButton.addTarget(
            self,
            action: #selector(profileInfoButtonTapped),
            for: .touchUpInside
        )
        
        recentSearchView.delegate = self
    }
    
    @objc private func profileInfoButtonTapped() {
        //TODO: Profile 변경으로 이동
        print("Profile Edit")
    }
    
    @objc private func searchButtonTapped() {
        navigationController?.pushViewController(
            SearchViewController(),
            animated: true
        )
    }
}

extension CinemaViewController: RecentSearchViewDelegate {
    func keywordButtonTapped(tag: Int) {
        navigationController?.pushViewController(
            SearchViewController(searchKeyword: UserDefaultsManager.shared.searchHistory[tag]),
            animated: true
        )
    }
}
