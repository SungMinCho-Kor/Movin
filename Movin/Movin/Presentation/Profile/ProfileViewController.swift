//
//  ProfileViewController.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private let profleImageview = ProfileEditButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldUnderlineView = UIView()
    private let alertLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    override func configureHierarchy() {
        [
            profleImageview,
            nicknameTextField,
            nicknameTextFieldUnderlineView,
            alertLabel
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profleImageview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profleImageview.snp.bottom).offset(32)
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
    }
    
    override func configureViews() {
        profleImageview.setImage(
            UIImage(named: "profile_\(Int.random(in: 0...11))")?
                .resize(
                    newWidth: 100,
                    newHeight: 100
                )
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
        alertLabel.text = "ㅇ제댜러제ㅑㄹ"
        alertLabel.isHidden = true
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
            alertLabel.isHidden = false
            alertLabel.text = "2글자 이상 10글자 미만으로 설정해주세요."
        } else if !text.matches(of: /[@#\$%]/).isEmpty {
            alertLabel.isHidden = false
            alertLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
        } else if !text.matches(of: /\d/).isEmpty {
            alertLabel.isHidden = false
            alertLabel.text = "닉네임에 숫자를 포함할 수 없어요"
        } else {
            alertLabel.text = "사용할 수 있는 닉네임이에요"
            alertLabel.isHidden = false
        }
    }
}
