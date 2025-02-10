//
//  SynopsisView.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

final class SynopsisView: BaseView {
    private let headerLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let emptyLabel = UILabel()
    private let moreButton = UIButton()
    
    override func configureHierarchy() {
        [
            headerLabel,
            synopsisLabel,
            moreButton,
            emptyLabel
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "Synopsis"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        synopsisLabel.font = .systemFont(ofSize: 14)
        synopsisLabel.textColor = .black
        synopsisLabel.numberOfLines = 3
        
        var attributedString = AttributedString("More")
        attributedString.font = .systemFont(
            ofSize: 14,
            weight: .bold
        )
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.titlePadding = .zero
        buttonConfiguration.attributedTitle = attributedString
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.titlePadding = .zero
        moreButton.configuration = buttonConfiguration
        
        moreButton.addTarget(
            self,
            action: #selector(moreButtonTapped),
            for: .touchUpInside
        )
        
        emptyLabel.text = "줄거리가 없습니다"
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .darkGray
        emptyLabel.isHidden = true
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        var attributedString = AttributedString(synopsisLabel.numberOfLines == 0 ? "More" : "Hide")
        attributedString.font = .systemFont(
            ofSize: 14,
            weight: .bold
        )
        sender.configuration?.attributedTitle = attributedString
        
        synopsisLabel.numberOfLines = synopsisLabel.numberOfLines == 0 ? 3 : 0
    }
    
    func configure(synopsis: String) {
        if synopsis.isEmpty {
            showEmptyView()
        } else {
            synopsisLabel.text = synopsis
        }
    }
    
    private func showEmptyView() {
        synopsisLabel.isHidden = true
        emptyLabel.isHidden = false
        moreButton.isHidden = true
    }
}
