//
//  ProfileImageEditViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

protocol ProfileDelegate: AnyObject {
    func setProfile(_ profileImage: MovinProfileImage)
}

final class ProfileImageEditViewController: BaseViewController {
    //TODO: ImageView 역할인데 이미 만들어 놓은 Button을 쓰는 것이 맞을까?
    private let currentProfile = ProfileEditButton()
    private lazy var profileCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout()
    )
    private let imageList: [UIImage] = [
        .profile0, .profile1, .profile2,
        .profile3, .profile4, .profile5,
        .profile6, .profile7, .profile8,
        .profile9, .profile10, .profile11
    ]
    private var profileImage: MovinProfileImage
    weak var profileDelegate: ProfileDelegate?
    
    init(profileImage: MovinProfileImage) {
        self.profileImage = profileImage
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedImage()
        configureNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileDelegate?.setProfile(profileImage)
    }
    
    override func configureHierarchy() {
        [
            currentProfile,
            profileCollectionView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        currentProfile.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(currentProfile.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(360) //TODO: 비율로 정했을 때 높이 구하는 방법
        }
    }
    
    override func configureViews() {
        currentProfile.setImage(profileImage.image)
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(
            ProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier
        )
        profileCollectionView.backgroundColor = .movinBlack
    }
    
    private func configureNavigation() {
        if UserDefaultsManager.shared.isOnboardingDone {
            navigationItem.title = "프로필 이미지 편집"
        } else {
            navigationItem.title = "프로필 이미지 설정"
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            print(#function, "no window")
            return layout
        }
        let width = window.bounds.width
        let spacing: CGFloat = 20
        let inset: CGFloat = 20
        let itemCount: CGFloat = 4
        let itemSize: CGFloat = (width - (spacing * (itemCount - 1)) - inset * 2) / itemCount
        layout.itemSize = CGSize(
            width: itemSize,
            height: itemSize
        )
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: inset,
            bottom: 0,
            right: inset
        )
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
    
    private func setSelectedImage() {
        profileCollectionView.selectItem(
            at: IndexPath(
                item: profileImage.rawValue,
                section: 0
            ),
            animated: false,
            scrollPosition: .centeredHorizontally
        )
    }
}

extension ProfileImageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: imageList[indexPath.row])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let newProfileImage = MovinProfileImage(rawValue: indexPath.row) else {
            print(#function, "MovinProfileImage wrong")
            return
        }
        currentProfile.setImage(newProfileImage.image)
        profileImage = newProfileImage
    }
}
