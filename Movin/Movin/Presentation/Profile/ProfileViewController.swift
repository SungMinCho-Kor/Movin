//
//  ProfileViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

enum Setting: String, CaseIterable {
    case faq = "자주 묻는 질문"
    case contactSupport = "1:1 문의"
    case notification = "알림 설정"
    case deleteAccount = "탈퇴하기"
}

final class ProfileViewController: BaseViewController {
    private let profileView = CinemaProfileView()
    private let settingTableView = UITableView()
    private let alertController = UIAlertController(
        title: "탈퇴하기",
        message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
        preferredStyle: .alert
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.refreshView()
    }
    
    override func configureHierarchy() {
        [
            profileView,
            settingTableView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViews() {
        navigationItem.title = "설정"
        
        profileView.profileInfoButton.addTarget(
            self,
            action: #selector(profileInfoButtonTapped),
            for: .touchUpInside
        )
        
        settingTableView.backgroundColor = .white
        settingTableView.separatorColor = .darkGray
        settingTableView.bounces = false
        settingTableView.rowHeight = 56
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        alertController.addAction(
            UIAlertAction(
                title: "취소",
                style: .cancel
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "확인",
                style: .destructive,
                handler: { _ in
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else {
                        return
                    }
                    UserDefaultsManager.shared.resetUserData()
                    window.rootViewController = BasicNavigationController(rootViewController: OnboardingViewController())
                    window.makeKeyAndVisible()
                }
            )
        )
    }
    
    @objc private func profileInfoButtonTapped() {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.delegate = self
        present(
            BasicNavigationController(rootViewController: profileEditViewController),
            animated: true
        )
    }
}

extension ProfileViewController: ProfileSaveDelegate {
    func reloadProfile() {
        profileView.refreshView()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        var configuration = cell.defaultContentConfiguration()
        configuration.text = Setting.allCases[indexPath.row].rawValue
        configuration.textProperties.color = .black
        configuration.textProperties.font = .systemFont(ofSize: 16)
        cell.contentConfiguration = configuration
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == Setting.allCases.count - 1 {//TODO: 탈퇴하기 확인 방법 고민
            present(
                alertController,
                animated: true
            )
        }
    }
}
