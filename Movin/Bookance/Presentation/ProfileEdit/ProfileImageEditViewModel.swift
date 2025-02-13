//
//  ProfileImageEditViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/7/25.
//

final class ProfileImageEditViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let selectCell: Observable<Int>
        let viewWillDisappear: Observable<Void> = Observable(())
    }
    
    struct Output {
        let setSelectedItem: Observable<Int>
        let navigationItemTitle: Observable<String>
        let delegateSetProfile: Observable<MovinProfileImage>
    }
    
    private var selectedProfileImage: MovinProfileImage
    
    init(selectedProfileImage: MovinProfileImage) {
        self.selectedProfileImage = selectedProfileImage
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            setSelectedItem: Observable(selectedProfileImage.rawValue),
            navigationItemTitle: Observable(UserDefaultsManager.shared.isOnboardingDone ? "프로필 이미지 편집" : "프로필 이미지 설정"),
            delegateSetProfile: Observable(selectedProfileImage)
        )
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            output.navigationItemTitle.value = UserDefaultsManager.shared.isOnboardingDone ? "프로필 이미지 편집" : "프로필 이미지 설정"
            output.setSelectedItem.value = self.selectedProfileImage.rawValue
        }
        
        input.selectCell.bind { [weak self] row in
            guard let nextSelectedProfileImage = MovinProfileImage(rawValue: row) else {
                print(#function, "MovinProfileImage rawValue Wrong")
                return
            }
            self?.selectedProfileImage = nextSelectedProfileImage
            output.setSelectedItem.value = row
        }
        
        input.viewWillDisappear.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            output.delegateSetProfile.value = selectedProfileImage
        }
        
        return output
    }
}
