//
//  CinemaProfileView.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class CinemaProfileView: BaseView {
    let profileInfoButton = ProfileInfoButton()
    let movieBoxButton = UIButton()//TODO: 커스텀 뷰 내부의 버튼에서 addTarget을 해야한다면 private을 푸는 것이 좋을까? delegate로 하는 것이 좋을까?
    
    override func configureHierarchy() {
        [
            profileInfoButton,
            movieBoxButton
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        profileInfoButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.5).offset(-16)
        }
        
        movieBoxButton.snp.makeConstraints { make in
            make.top.equalTo(profileInfoButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        var attributedString = AttributedString("\(UserDefaultsManager.shared.likeMovies.count) 개의 무비박스 보관중")
        attributedString.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = attributedString
        buttonConfiguration.baseForegroundColor = .movinWhite
        buttonConfiguration.baseBackgroundColor = .movinPrimary.withAlphaComponent(0.8)
        movieBoxButton.configuration = buttonConfiguration
        
        layer.cornerRadius = 20
        backgroundColor = .movinDarkGray.withAlphaComponent(0.4)
    }
    
    func refreshView() {
        var attributedString = AttributedString("\(UserDefaultsManager.shared.likeMovies.count) 개의 무비박스 보관중")
        attributedString.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        movieBoxButton.configuration?.attributedTitle = attributedString
        profileInfoButton.refreshView()
    }
}
