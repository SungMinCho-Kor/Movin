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
        
        var color: MovinSystemColor {
            switch self {
            case .success:
                return .primary
            default:
                return .alert
            }
        }
    }
    
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let profileImageButtonTapped: Observable<Void> = Observable(())
        let profileChanged: Observable<MovinProfileImage?> = Observable(nil)
        let nicknameChanged: Observable<String> = Observable(" ")
        let completeButtonTapped: Observable<Void> = Observable(())
        let rightBarButtonTapped: Observable<Void> = Observable(())
        let cellSelect: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        let navigationTitle: Observable<String>
        let profileImage: Observable<MovinProfileImage>
        let alertLabelText: Observable<String>
        let alertLabelColor: Observable<MovinSystemColor>
        let convertToEdit: Observable<Void>
        let isCompleteButtonEnabled: Observable<Bool>
        let complete: Observable<Void>
        let dismiss: Observable<Void>
        let presentProfileImageEditViewController: Observable<Int>
        let reloadMBTI: Observable<Void>
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
    var mbtiElement = UserDefaultsManager.shared.mbti
    
    func transform(input: Input) -> Output {
        let navigationTitle: Observable<String> = Observable("")
        let profileImage: Observable<MovinProfileImage> = Observable(profileImage)
        let alertLabelText: Observable<String> = Observable(" ")
        let alertLabelColor: Observable<MovinSystemColor> = Observable(.primary)
        let convertToEdit: Observable<Void> = Observable(())
        let isCompleteButtonEnabled: Observable<Bool> = Observable(false)
        let complete: Observable<Void> = Observable(())
        let dismiss: Observable<Void> = Observable(())
        let presentProfileImageEditViewController: Observable<Int> = Observable(self.profileImage.rawValue)
        let reloadMBTI: Observable<Void> = Observable(())
        
        let output = Output(
            navigationTitle: navigationTitle,
            profileImage: profileImage,
            alertLabelText: alertLabelText,
            alertLabelColor: alertLabelColor,
            convertToEdit: convertToEdit,
            isCompleteButtonEnabled: isCompleteButtonEnabled,
            complete: complete,
            dismiss: dismiss,
            presentProfileImageEditViewController: presentProfileImageEditViewController,
            reloadMBTI: reloadMBTI
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
                output.convertToEdit.value = ()
            } else {
                let randomImage = MovinProfileImage.allCases.randomElement()!
                output.profileImage.value = randomImage
                self?.profileImage = randomImage
                output.navigationTitle.value = "프로필 설정"
            }
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
            output.isCompleteButtonEnabled.value = alertCase == .success && mbtiElement.isFull()
            output.alertLabelColor.value = alertCase.color
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
            UserDefaultsManager.shared.mbti = self.mbtiElement
            output.complete.value = ()
        }
        
        input.rightBarButtonTapped.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            UserDefaultsManager.shared.nickname = nickname
            UserDefaultsManager.shared.profileImageIndex = self.profileImage.rawValue
            UserDefaultsManager.shared.mbti = self.mbtiElement
            output.dismiss.value = ()
        }
        
        input.cellSelect.bind { [weak self] index in
            guard let index else {
                print(#function, "no index")
                return
            }
            
            self?.mbtiElement.select(index: index)
            output.reloadMBTI.value = ()
            guard let alertCase = self?.getAlertCase() else {
                return
            }
            output.isCompleteButtonEnabled.value = alertCase == .success && self?.mbtiElement.isFull() == true
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
