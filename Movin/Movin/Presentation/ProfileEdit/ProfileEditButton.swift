//
//  ProfileEditButton.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit
import SnapKit

final class ProfileEditButton: BaseButton {
    private let profileImageView = ProfileImageView()
    private let editImageView = UIImageView()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        [
            profileImageView,
            editImageView
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        editImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.size.equalTo(30)
        }
    }
    
    override func configureViews() {
        profileImageView.changeSelection(to: true)
        
        editImageView.contentMode = .center
        editImageView.image = UIImage(systemName: "camera.fill")?
            .resizeKeepRatio(newWidth: 20)
            .withTintColor(
                .movinWhite,
                renderingMode: .alwaysOriginal
            )
        editImageView.backgroundColor = .movinPrimary
        editImageView.layer.cornerRadius = 15
        editImageView.clipsToBounds = true
    }
    
    func setImage(_ image: UIImage?) {
        profileImageView.image = image
    }
}
