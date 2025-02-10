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
    private let headerLabel = UILabel()
    private let emptyLabel = UILabel()
    private let removeAllButton = UIButton()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    weak var delegate: RecentSearchViewDelegate?
    
    override func configureHierarchy() {
        [
            headerLabel,
            removeAllButton,
            scrollView,
            emptyLabel
        ].forEach(addSubview)
        scrollView.addSubview(stackView)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(28)
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "최근검색어"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        let attributedTitle = NSAttributedString(
            string: "전체 삭제",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        removeAllButton.setAttributedTitle(
            attributedTitle,
            for: .normal
        )
        removeAllButton.isHidden = UserDefaultsManager.shared.searchHistory.isEmpty
        removeAllButton.addTarget(
            self,
            action: #selector(removeAllRecentSearchHistoryButtonTapped),
            for: .touchUpInside
        )
        
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        
        configureRecentSearchHistory()
        
        emptyLabel.text = "최근 검색어 내역이 없습니다."
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textColor = .darkGray
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
    }
    
    private func configureRecentSearchHistory() {
        emptyLabel.isHidden = !UserDefaultsManager.shared.searchHistory.isEmpty
        removeAllButton.isHidden = UserDefaultsManager.shared.searchHistory.isEmpty
        for idx in 0..<UserDefaultsManager.shared.searchHistory.count {
            let keyword = UserDefaultsManager.shared.searchHistory[idx]
            let buttonView = RecentSearchKeywordButtonView()
            buttonView.setTitle(keyword)
            stackView.addArrangedSubview(buttonView)
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
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
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
