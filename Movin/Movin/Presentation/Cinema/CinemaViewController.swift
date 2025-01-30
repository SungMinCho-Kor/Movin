//
//  CinemaViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class CinemaViewController: BaseViewController {
    private let profileView = CinemaProfileView()
    private let recentSearchHeader = UILabel()
    private let recentEmptyLabel = UILabel()
    private let recentSearchScrollView = UIScrollView()
    private let recentSearchStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.refreshView()
        refreshView()
    }
    
    override func configureHierarchy() {
        [
            profileView,
            recentSearchHeader,
            recentSearchScrollView,
            recentEmptyLabel
        ].forEach(view.addSubview)
        recentSearchScrollView.addSubview(recentSearchStackView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.18)
        }
        
        recentSearchHeader.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        recentSearchScrollView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchHeader.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        recentSearchStackView.snp.makeConstraints { make in
            make.edges.equalTo(recentSearchScrollView)//TODO: 맞나?
            make.height.equalTo(recentSearchScrollView)
        }
        
        recentEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(recentSearchScrollView)
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
        
        recentSearchHeader.text = "최근검색어"
        recentSearchHeader.textColor = .movinWhite
        recentSearchHeader.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        recentSearchStackView.spacing = 8
        recentSearchStackView.distribution = .fillProportionally
        
        recentSearchScrollView.showsVerticalScrollIndicator = false
        recentSearchScrollView.showsHorizontalScrollIndicator = false
        recentSearchScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        
        configureRecentSearchHistory()
        
        recentEmptyLabel.text = "최근 검색어 내역이 없습니다."
        recentEmptyLabel.font = .systemFont(ofSize: 14)
        recentEmptyLabel.textColor = .movinDarkGray
        recentEmptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
    }
    
    @objc private func profileInfoButtonTapped() {
        print("Profile Edit")
    }
    
    @objc private func searchButtonTapped() {
        navigationController?.pushViewController(
            SearchViewController(),
            animated: true
        )
    }
    
    private func refreshView() {
        recentSearchStackView.arrangedSubviews.forEach { subview in
            recentSearchStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        configureRecentSearchHistory()
    }
    
    private func configureRecentSearchHistory() {
        recentEmptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
        for idx in 0..<UserDefaultsManager.shared.searchHistory.count {
            let keyword = UserDefaultsManager.shared.searchHistory[idx]
            let buttonView = RecentSearchKeywordButtonView()
            buttonView.setTitle(keyword)
            recentSearchStackView.addArrangedSubview(buttonView)
            buttonView.keywordButton.tag = idx
            buttonView.removeButton.tag = idx
            buttonView.keywordButton.addTarget(
                self,
                action: #selector(keywordButtonTapped),
                for: .touchUpInside
            )
            buttonView.removeButton.addTarget(
                self,
                action: #selector(removeButtonTapped),
                for: .touchUpInside
            )
        }
    }
    
    @objc private func keywordButtonTapped(_ sender: UIButton) {
        print(#function, sender.tag)
        
    }
    
    @objc private func removeButtonTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.removeSearchHistory(index: sender.tag)
        refreshView()
    }
}
