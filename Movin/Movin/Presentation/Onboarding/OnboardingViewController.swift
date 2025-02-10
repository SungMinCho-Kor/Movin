//
//  OnboardingViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = BorderedButton()
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            descriptionLabel,
            startButton
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.65)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .white
        
        imageView.image = .onboarding
        
        titleLabel.text = "Movin"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(
            ofSize: 36,
            weight: .bold
        )
        
        descriptionLabel.text = "당신만의 영화 세상,\nMovin을 시작해보세요."
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        
        startButton.setTitle(
            "시작하기",
            for: .normal
        )
        startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func startButtonTapped() {
        navigationController?.pushViewController(
            ProfileEditViewController(),
            animated: true
        )
    }
}
