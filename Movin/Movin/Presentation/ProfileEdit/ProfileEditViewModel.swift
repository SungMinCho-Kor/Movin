//
//  ProfileEditViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/6/25.
//

import Foundation

final class ProfileEditViewModel: ViewModel {
    
    enum ProfileAlert: String {
        case length = "2글자 이상 10글자 미만으로 설정해주세요."
        case special = "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case digit = "닉네임에 숫자를 포함할 수 없어요"
        case success = "사용할 수 있는 닉네임이에요"
    }
    
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let profileImageButtonTapped: Observable<Void> = Observable(())
        let profileChanged: Observable<MovinProfileImage?> = Observable(nil)
        let nicknameChanged: Observable<String> = Observable(" ")
        let mbtiChanged: Observable<Void> = Observable(())// TODO 수정
        let completeButtonTapped: Observable<Void> = Observable(())
        let rightBarButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        let navigationTitle: Observable<String>
        let profileImage: Observable<MovinProfileImage>
        let alertLabelText: Observable<String>
        let completeLocationToggle: Observable<Bool>
        let isCompleteButtonEnabled: Observable<Bool>
        let complete: Observable<Void>
        let dismiss: Observable<Void>
        let presentProfileImageEditViewController: Observable<Int>
    }
    
    private var nickname: String = UserDefaultsManager.shared.nickname
    private var profileImage: MovinProfileImage = {
        if let index = UserDefaultsManager.shared.profileImageIndex,
           let image = MovinProfileImage(rawValue: index) {
            return image
        } else {
            return MovinProfileImage.allCases.randomElement()!
        }
    }()
    
    func transform(input: Input) -> Output {
        let navigationTitle: Observable<String> = Observable("")
        let profileImage: Observable<MovinProfileImage> = Observable(profileImage)
        let alertLabelText: Observable<String> = Observable(" ")
        let completeLocationToggle: Observable<Bool> = Observable(UserDefaultsManager.shared.isOnboardingDone)
        let isCompleteButtonEnabled: Observable<Bool> = Observable(false)
        let complete: Observable<Void> = Observable(())
        let dismiss: Observable<Void> = Observable(())
        let presentProfileImageEditViewController: Observable<Int> = Observable(self.profileImage.rawValue)
        
        let output = Output(
            navigationTitle: navigationTitle,
            profileImage: profileImage,
            alertLabelText: alertLabelText,
            completeLocationToggle: completeLocationToggle,
            isCompleteButtonEnabled: isCompleteButtonEnabled,
            complete: complete,
            dismiss: dismiss,
            presentProfileImageEditViewController: presentProfileImageEditViewController
        )
        
        input.viewDidLoad.bind { [weak self] _ in
            if UserDefaultsManager.shared.isOnboardingDone {
                guard let prevProfileImageIndex = UserDefaultsManager.shared.profileImageIndex,
                      let prevProfileImage = MovinProfileImage(rawValue: prevProfileImageIndex) else {
                    print(#function, "UserDefaultsManager.shared.profileImageIndex Wrong")
                    return
                }
                output.profileImage.value = prevProfileImage
                self?.profileImage = prevProfileImage
                output.navigationTitle.value = "프로필 편집"
            } else {
                let randomImage = MovinProfileImage.allCases.randomElement()!
                output.profileImage.value = randomImage
                self?.profileImage = randomImage
                output.navigationTitle.value = "프로필 설정"
            }
            output.completeLocationToggle.value = UserDefaultsManager.shared.isOnboardingDone
        }
        
        input.profileImageButtonTapped.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            output.presentProfileImageEditViewController.value = self.profileImage.rawValue
        }
        
        input.profileChanged.bind { [weak self] image in
            guard let image else {
                print(#function, "No ProfileImage Input")
                return
            }
            self?.profileImage = image
            output.profileImage.value = image
        }
        
        input.nicknameChanged.bind { [weak self] nickname in
            guard let self else {
                print(#function, "No Self")
                return
            }
            self.nickname = nickname
            let alertCase = self.getAlertCase()
            output.alertLabelText.value = alertCase.rawValue
            output.isCompleteButtonEnabled.value = alertCase == .success //TODO: MBTI 다 있는지 고려
        }
        
        input.completeButtonTapped.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            UserDefaultsManager.shared.nickname = nickname
            UserDefaultsManager.shared.profileImageIndex = self.profileImage.rawValue
            UserDefaultsManager.shared.isOnboardingDone = true
            UserDefaultsManager.shared.signUpDate = Date()
            // TODO: MBTI도 저장
            output.complete.value = ()
        }
        
        input.rightBarButtonTapped.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            UserDefaultsManager.shared.nickname = nickname
            UserDefaultsManager.shared.profileImageIndex = self.profileImage.rawValue
            // TODO: MBTI도 저장
            output.dismiss.value = ()
        }
        
        return output
    }
    
    private func updateAlertLabelText(alertType: ProfileAlert, output: Output) {
        output.alertLabelText.value = alertType.rawValue
    }
    
    private func getAlertCase() -> ProfileAlert {
        if nickname.count >= 10 || nickname.count < 2 {
            return .length
        } else if !nickname.matches(of: /[@#\$%]/).isEmpty {
            return .special
        } else if !nickname.matches(of: /\d/).isEmpty {
            return .digit
        } else {
            return .success
        }
    }
}
