//
//  RecentSearchView.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

protocol RecentSearchViewDelegate: AnyObject {
    func keywordButtonTapped(tag: Int)
}

final class RecentSearchView: BaseView {
    private let recentSearchHeader = UILabel()
    private let recentSearchHistoryEmptyLabel = UILabel()
    private let removeAllRecentSearchHistoryButton = UIButton()
    private let recentSearchScrollView = UIScrollView()
    private let recentSearchStackView = UIStackView()
    weak var delegate: RecentSearchViewDelegate?
    
    override func configureHierarchy() {
        [
            recentSearchHeader,
            removeAllRecentSearchHistoryButton,
            recentSearchScrollView,
            recentSearchHistoryEmptyLabel
        ].forEach(addSubview)
        recentSearchScrollView.addSubview(recentSearchStackView)
    }
    
    override func configureLayout() {
        recentSearchHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        removeAllRecentSearchHistoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchHeader)
            make.trailing.equalToSuperview().inset(16)
        }
        
        recentSearchScrollView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchHeader.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        recentSearchStackView.snp.makeConstraints { make in
            make.edges.equalTo(recentSearchScrollView)
            make.height.equalTo(recentSearchScrollView)
        }
        
        recentSearchHistoryEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(recentSearchScrollView)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        recentSearchHeader.text = "최근검색어"
        recentSearchHeader.textColor = .movinWhite
        recentSearchHeader.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        //TODO: 왜 attribute에서 설정해줬는데 자꾸 흰색으로 변할까요...
        let attributedTitle = NSAttributedString(
            string: "전체 삭제",
            attributes: [
                .foregroundColor: UIColor.movinPrimary,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        removeAllRecentSearchHistoryButton.setAttributedTitle(
            attributedTitle,
            for: .normal
        )
        removeAllRecentSearchHistoryButton.isHidden = UserDefaultsManager.shared.searchHistory.isEmpty
        removeAllRecentSearchHistoryButton.addTarget(
            self,
            action: #selector(removeAllRecentSearchHistoryButtonTapped),
            for: .touchUpInside
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
        
        recentSearchHistoryEmptyLabel.text = "최근 검색어 내역이 없습니다."
        recentSearchHistoryEmptyLabel.font = .systemFont(ofSize: 14)
        recentSearchHistoryEmptyLabel.textColor = .movinDarkGray
        recentSearchHistoryEmptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
    }
    
    private func configureRecentSearchHistory() {
        recentSearchHistoryEmptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
        removeAllRecentSearchHistoryButton.isHidden = UserDefaultsManager.shared.searchHistory.isEmpty
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
    
    func refreshView() {
        recentSearchStackView.arrangedSubviews.forEach { subview in
            recentSearchStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        configureRecentSearchHistory()
    }
    
    @objc private func keywordButtonTapped(_ sender: UIButton) {
        delegate?.keywordButtonTapped(tag: sender.tag)
    }
    
    @objc private func removeButtonTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.removeSearchHistory(index: sender.tag)
        refreshView()
    }
    
    @objc private func removeAllRecentSearchHistoryButtonTapped() {
        UserDefaultsManager.shared.searchHistory.removeAll()
        refreshView()
    }
}
