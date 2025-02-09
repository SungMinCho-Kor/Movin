//
//  TodayMovieCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let likeButton = UIButton()
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            descriptionLabel,
            likeButton
        ].forEach(contentView.addSubview)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.backgroundColor = .movinDarkGray
        titleLabel.text = ""
        descriptionLabel.text = "\n"//TODO: 이게 최선일까?
        likeButton.isSelected = false
    }
    
    override func configureLayout() { //TODO: 아래서부터 잡는 레이아웃이 최선일까?
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(likeButton.snp.leading)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        
        likeButton.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal
        )
        titleLabel.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
    }
    
    override func configureViews() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.textColor = .movinWhite
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        descriptionLabel.textColor = .movinWhite
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 2
        
        likeButton.setImage(
            UIImage(systemName: "heart"),
            for: .normal
        )
        likeButton.setImage(
            UIImage(systemName: "heart.fill"),
            for: .selected
        )
        likeButton.tintColor = .movinPrimary
    }
    
    func configure(content: TodayMovie) {
        if let posterPath = content.poster_path {
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFill
            imageView.setImage(with: Environment.imageBaseURL.value + "/w500" + posterPath)
        } else {
            imageView.backgroundColor = .movinDarkGray
            imageView.image = UIImage(systemName: "xmark.octagon.fill")
            imageView.tintColor = .movinBackground
            imageView.contentMode = .center
        }
        titleLabel.text = content.title
        if content.overview.isEmpty {
            descriptionLabel.text = "\n"
        } else {
            descriptionLabel.text = content.overview
        }
        likeButton.isSelected = UserDefaultsManager.shared.likeMovies.contains(content.id)
    }
}
