//
//  ProfileView.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class ProfileView: BaseView {
    let profileInfoButton = ProfileInfoButton()
    let storageButton = UIButton()
    
    override func configureHierarchy() {
        [
            profileInfoButton,
            storageButton
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        profileInfoButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-16)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(profileInfoButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        var attributedString = AttributedString("\(UserDefaultsManager.shared.likeBooks.count) 개의 북캉스 보관중")
        attributedString.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = attributedString
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.baseBackgroundColor = .darkGray.withAlphaComponent(0.7)
        storageButton.configuration = buttonConfiguration
        
        layer.cornerRadius = 20
        backgroundColor = .darkGray.withAlphaComponent(0.5)
        
        storageButton.isUserInteractionEnabled = false
    }
    
    func refreshView() {
        var attributedString = AttributedString("\(UserDefaultsManager.shared.likeBooks.count) 개의 북캉스 보관중")
        attributedString.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        storageButton.configuration?.attributedTitle = attributedString
        profileInfoButton.refreshView()
    }
}
