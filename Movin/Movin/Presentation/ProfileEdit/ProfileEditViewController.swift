//
//  ProfileEditViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

protocol ProfileSaveDelegate: AnyObject {
    func reloadProfile()
}

final class ProfileEditViewController: BaseViewController {
    private let viewModel = ProfileEditViewModel()
    
    private let profileEditButton = ProfileEditButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldUnderlineView = UIView()
    private let alertLabel = UILabel()
    private let completeButton = BorderedButton()
    weak var delegate: ProfileSaveDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        input.viewDidLoad.value = ()
    }
    
    private let input = ProfileEditViewModel.Input()
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.navigationTitle.bind { [weak self] navigationTitle in
            self?.navigationItem.title = navigationTitle
        }
        
        output.convertToEdit.bind { [weak self] _ in
            guard let self else {
                print(#function, "No self")
                return
            }
            navigationItem.setRightBarButtonItems(
                [
                    UIBarButtonItem(
                        title: "저장",
                        style: .plain,
                        target: self,
                        action: #selector(saveButtonTapped)
                    )
                ],
                animated: true
            )
            navigationItem.setLeftBarButtonItems(
                [
                    UIBarButtonItem(
                        image: UIImage(systemName: "xmark") ,
                        style: .plain,
                        target: self,
                        action: #selector(closeButtonTapped)
                    )
                ],
                animated: true
            )
            completeButton.isHidden = true
        }
        
        output.profileImage.bind { [weak self] image in
            self?.profileEditButton.setImage(
                image.image?.resize(
                    newWidth: 100,
                    newHeight: 100
                )
            )
        }
        
        output.alertLabelText.bind { [weak self] alert in
            self?.alertLabel.text = alert
        }
        
        output.isCompleteButtonEnabled.bind { [weak self] isEnabled in
            self?.completeButton.isEnabled = isEnabled
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        
        output.complete.bind { _ in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }
            window.rootViewController = TabBarController()
            window.makeKeyAndVisible()
        }
        
        output.dismiss.bind { [weak self] _ in
            self?.dismiss(animated: true)
            self?.delegate?.reloadProfile()
        }
        
        output.presentProfileImageEditViewController.bind { [weak self] index in
            guard let profileImage = MovinProfileImage(rawValue: index) else {
                print("Wrong MovinProfileImage Index")
                return
            }
            let profileImageEditViewController = ProfileImageEditViewController(
                viewModel: ProfileImageEditViewModel(selectedProfileImage: profileImage),
                selectedIndex: profileImage.rawValue
            )
            profileImageEditViewController.profileDelegate = self
            self?.navigationController?.pushViewController(
                profileImageEditViewController,
                animated: true
            )
        }
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
        nicknameTextField.autocorrectionType = .no
        nicknameTextField.autocapitalizationType = .none
        
        nicknameTextFieldUnderlineView.backgroundColor = .movinWhite
        
        alertLabel.textColor = .movinPrimary
        alertLabel.font = .systemFont(ofSize: 14)
        alertLabel.text = " "
        
        nicknameTextField.text = UserDefaultsManager.shared.nickname
        
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
    
    @objc private func nicknameTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            print(#function, "nickname text is nil")
            return
        }
        input.nicknameChanged.value = text
    }
    
    @objc private func completeButtonTapped() {
        input.completeButtonTapped.value = ()
    }
    
    @objc private func profileEditButtonTapped() {
        input.profileImageButtonTapped.value = ()
    }
    
    @objc private func saveButtonTapped() {
        input.rightBarButtonTapped.value = ()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

extension ProfileEditViewController: ProfileDelegate {
    func setProfile(_ profileImage: MovinProfileImage) {
        input.profileChanged.value = profileImage
    }
}
