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
    private let viewModel: ProfileImageEditViewModel
    
    //TODO: ImageView 역할인데 이미 만들어 놓은 Button을 쓰는 것이 맞을까?
    private let currentProfile = ProfileEditButton()
    private lazy var profileCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout()
    )
    weak var profileDelegate: ProfileDelegate?
    
    private let input: ProfileImageEditViewModel.Input
    
    // TODO: selectedIndex를 UserDefault에서 가져오기 (Int?)
    init(
        viewModel: ProfileImageEditViewModel,
        selectedIndex: Int
    ) {
        self.viewModel = viewModel
        self.input = ProfileImageEditViewModel.Input(selectCell: Observable(selectedIndex))
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        input.viewDidLoad.value = ()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.delegateSetProfile.bind { [weak self] image in
            self?.profileDelegate?.setProfile(image)
        }
        
        output.navigationItemTitle.bind { [weak self] navigationItemTitle in
            self?.navigationItem.title = navigationItemTitle
        }
        
        output.setSelectedItem.bind { [weak self] row in
            guard let newProfileImage = MovinProfileImage(rawValue: row) else {
                print(#function, "MovinProfileImage wrong")
                return
            }
            self?.currentProfile.setImage(newProfileImage.image)
            self?.profileCollectionView.selectItem(
                at: IndexPath(
                    row: row,
                    section: 0
                ),
                animated: true,
                scrollPosition: .centeredHorizontally
            )
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        input.viewWillDisappear.value = ()
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
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(
            ProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier
        )
        profileCollectionView.backgroundColor = .movinBlack
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
}

extension ProfileImageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return MovinProfileImage.allCases.count
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
        cell.configure(image: MovinProfileImage.allCases[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        input.selectCell.value = indexPath.row
    }
}
