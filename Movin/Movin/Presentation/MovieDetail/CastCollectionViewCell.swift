//
//  CastCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    private let nameStackView = UIStackView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        profileImageView.backgroundColor = .movinDarkGray
        nameLabel.text = ""
        characterLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }
    
    override func configureHierarchy() {
        [
            profileImageView,
            nameStackView
        ].forEach(addSubview)
        [
            nameLabel,
            characterLabel
        ].forEach(nameStackView.addArrangedSubview)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(profileImageView)
        }
    }
    
    override func configureViews() {
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .movinDarkGray
        profileImageView.tintColor = .movinBackground
        
        nameStackView.spacing = 8
        nameStackView.alignment = .leading
        nameStackView.axis = .vertical
        
        nameLabel.textColor = .movinWhite
        nameLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        characterLabel.textColor = .movinDarkGray
        characterLabel.font = .systemFont(ofSize: 14)
    }
    
    func configure(cast: Cast) {
        if let profilePath = cast.profile_path {
            profileImageView.backgroundColor = .clear
            profileImageView.setImage(with: Environment.imageBaseURL.value + "/w500" + profilePath)
        } else {
            profileImageView.backgroundColor = .movinDarkGray
            profileImageView.image = UIImage(systemName: "person.fill")
        }
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
}
