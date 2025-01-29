//
//  ProfileEditViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private let profileEditButton = ProfileEditButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldUnderlineView = UIView()
    private let alertLabel = UILabel()
    private let completeButton = BorderedButton()
    private var currentImageIndex = UserDefaultsManager.shared.profileImageIndex {
        didSet {
            profileEditButton.setImage(UIImage(named: "profile_\(currentImageIndex)"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    override func configureHierarchy() {
        [
            profileEditButton,
            nicknameTextField,
            nicknameTextFieldUnderlineView,
            alertLabel,
            completeButton
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(44)
        }
        
        nicknameTextFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldUnderlineView.snp.bottom).offset(16)
            make.leading.equalTo(nicknameTextField)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }
    
    override func configureViews() {
        profileEditButton.setImage(
            UIImage(named: "profile_\(currentImageIndex)")?
                .resize(
                    newWidth: 100,
                    newHeight: 100
                )
        )
        profileEditButton.addTarget(
            self,
            action: #selector(profileEditButtonTapped),
            for: .touchUpInside
        )
        
        nicknameTextField.setPlaceholder("2~10글자, 특수문자(@, #, $, %) 및 숫자 사용 불가")
        nicknameTextField.addTarget(
            self,
            action: #selector(nicknameTextFieldChanged),
            for: .editingChanged
        )
        
        nicknameTextFieldUnderlineView.backgroundColor = .movinWhite
        
        alertLabel.textColor = .movinPrimary
        alertLabel.font = .systemFont(ofSize: 14)
        alertLabel.text = " "//TODO: 임시 방편 제거
        
        completeButton.setTitle(
            "완료",
            for: .normal
        )
        completeButton.setTitleColor(
            .movinPrimary,
            for: .disabled
        )
        completeButton.isEnabled = false
        completeButton.addTarget(
            self,
            action: #selector(completeButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func configureNavigation() {
        navigationItem.title = "프로필 설정"
    }
    
    @objc private func nicknameTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            print(#function, "nickname text is nil")
            return
        }
        if text.count >= 10 || text.count < 2 {
            alertLabel.text = "2글자 이상 10글자 미만으로 설정해주세요."
            completeButton.isEnabled = false
        } else if !text.matches(of: /[@#\$%]/).isEmpty {
            alertLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            completeButton.isEnabled = false
        } else if !text.matches(of: /\d/).isEmpty {
            alertLabel.text = "닉네임에 숫자를 포함할 수 없어요"
            completeButton.isEnabled = false
        } else {
            alertLabel.text = "사용할 수 있는 닉네임이에요"
            completeButton.isEnabled = true
        }
    }
    
    @objc private func completeButtonTapped() {
        UserDefaultsManager.shared.isOnboardingStarted = true
        guard let nickname = nicknameTextField.text else {
            print(#function, "nickname text nil")
            return
        }
        UserDefaultsManager.shared.nickname = nickname
        UserDefaultsManager.shared.profileImageIndex = currentImageIndex
        UserDefaultsManager.shared.signUpDate = Date()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()
    }
    
    @objc private func profileEditButtonTapped() {
        let profileImageEditViewController = ProfileImageEditViewController(currentImageIndex: currentImageIndex)
        profileImageEditViewController.profileDelegate = self
        navigationController?.pushViewController(
            profileImageEditViewController,
            animated: true
        )
    }
}

extension ProfileEditViewController: ProfileDelegate {
    func setProfile(index: Int) {
        currentImageIndex = index
    }
}
