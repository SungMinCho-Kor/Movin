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
    private let mbtiView = MBTIView()
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
        
        output.reloadMBTI.bind { [weak self] _ in
            self?.mbtiView.collectionView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        [
            profileEditButton,
            nicknameTextField,
            nicknameTextFieldUnderlineView,
            alertLabel,
            mbtiView,
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
        
        mbtiView.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(mbtiView.collectionView.snp.width).dividedBy(2)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-24)
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
        
        nicknameTextFieldUnderlineView.backgroundColor = .movinLabel
        
        alertLabel.textColor = .movinPrimary
        alertLabel.font = .systemFont(ofSize: 14)
        alertLabel.text = " "
        
        nicknameTextField.text = UserDefaultsManager.shared.nickname
        
        mbtiView.collectionView.delegate = self
        mbtiView.collectionView.dataSource = self
        
        completeButton.setTitle(
            "완료",
            for: .normal
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

extension ProfileEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.mbtiElement.getIndexList().count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MBTICollectionViewCell.identifier,
            for: indexPath
        ) as? MBTICollectionViewCell else {
            print(#function, "MBTICollectionViewCell Wrong")
            return UICollectionViewCell()
        }
        
        cell.configure(index: indexPath.row, isSelected: viewModel.mbtiElement.getIndexList()[indexPath.row])
        
        return cell
    }
    
    // TODO: 구현의 궁금증 - 일단 select를 false를 주고 검증 후에 select를 실행시키는 것이 좋을까?
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        input.cellSelect.value = indexPath.row
        return true
    }
}

extension ProfileEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.bounds.height
        
        return CGSize(width: height / 2 - 8, height: height / 2 - 8)
    }
}
