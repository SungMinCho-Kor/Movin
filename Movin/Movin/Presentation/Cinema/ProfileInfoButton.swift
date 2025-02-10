//
//  ProfileInfoButton.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class ProfileInfoButton: BaseButton {
    private let profileImageView = ProfileImageView()
    private let labelStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let signUpDateLabel = UILabel()
    private let selectionAccessoryImageView = UIImageView()

    override func configureHierarchy() {
        [
            profileImageView,
            labelStackView,
            selectionAccessoryImageView
        ].forEach(addSubview)
        [
            nicknameLabel,
            signUpDateLabel
        ].forEach(labelStackView.addArrangedSubview)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(profileImageView.snp.height)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.centerY.equalTo(profileImageView)
        }
        
        selectionAccessoryImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImageView)
            make.width.equalTo(12)
            make.height.equalTo(28)
        }
    }
    
    override func configureViews() {
        profileImageView.changeSelection(to: true)
        
        labelStackView.alignment = .leading
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.isUserInteractionEnabled = false
        
        nicknameLabel.text = UserDefaultsManager.shared.nickname
        nicknameLabel.textColor = .black
        nicknameLabel.font = .systemFont(
            ofSize: 16,
            weight: .black
        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let signUpDate = dateFormatter.string(from: UserDefaultsManager.shared.signUpDate)
        signUpDateLabel.text = "\(signUpDate) 가입"
        signUpDateLabel.font = .systemFont(ofSize: 14)
        signUpDateLabel.textColor = .darkGray
        
        selectionAccessoryImageView.image = UIImage(systemName: "greaterthan")?.withRenderingMode(.alwaysTemplate)
        selectionAccessoryImageView.contentMode = .scaleToFill
        selectionAccessoryImageView.tintColor = .black
    }
    
    func refreshView() {
        nicknameLabel.text = UserDefaultsManager.shared.nickname
        guard let index = UserDefaultsManager.shared.profileImageIndex,
                let image = MovinProfileImage(rawValue: index)?.image else {
            print("UserDefaultsManager.shared.profileImageIndex Wrong")
            return
        }
        profileImageView.image = image
    }
}
