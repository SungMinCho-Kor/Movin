//
//  RecentSearchKeywordButtonView.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class RecentSearchKeywordButtonView: BaseView {
    let keywordButton = UIButton()
    let removeButton = UIButton()
    
    init() {
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    override func configureHierarchy() {
        [
            keywordButton,
            removeButton
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        keywordButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.verticalEdges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(keywordButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        keywordButton.setTitleColor(
            .movinBlack,
            for: .normal
        )
        
        removeButton.tintColor = .movinBlack
        removeButton.setImage(
            UIImage(systemName: "xmark"),
            for: .normal
        )
        removeButton.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(
                pointSize: 12,
                weight: .medium
            ),
            forImageIn: .normal
        )
        
        backgroundColor = .white
        clipsToBounds = true
    }
    
    func setTitle(_ title: String) {
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.movinBlack,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        keywordButton.setAttributedTitle(
            attributedString,
            for: .normal
        )
    }
}
