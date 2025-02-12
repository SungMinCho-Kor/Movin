//
//  BookCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

import UIKit

final class BookCollectionViewCell: BaseCollectionViewCell {
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
        titleLabel.text = ""
        descriptionLabel.text = "\n"//TODO: 이게 최선일까?
        likeButton.isSelected = false
    }
    
    override func configureLayout() {
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
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading)
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        descriptionLabel.textColor = .black
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
        likeButton.tintColor = .systemRed
    }
    
    func configure(content: Book) {
        imageView.setImage(with: content.cover, placeholder: UIImage(systemName: "book.closed.fill"))
        titleLabel.text = content.title
        if content.description.isEmpty {
            descriptionLabel.text = "\n"
        } else {
            descriptionLabel.text = content.description
        }
        likeButton.isSelected = false //TODO: 수정
    }
}
