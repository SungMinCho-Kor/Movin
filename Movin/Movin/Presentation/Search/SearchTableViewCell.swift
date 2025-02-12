//
//  SearchTableViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class SearchTableViewCell: BaseTableViewCell {
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let publishInfoLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    let likeButton = UIButton()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        titleLabel.attributedText = nil
        publishInfoLabel.text = ""
        priceLabel.text = ""
        categoryLabel.text = ""
        likeButton.isSelected = false
    }
    
    override func configureHierarchy() {
        [
            coverImageView,
            titleLabel,
            publishInfoLabel,
            priceLabel,
            categoryLabel,
            likeButton
        ].forEach(contentView.addSubview)
    }
    
    override func configureLayout() {
        coverImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(16)
            make.width.equalTo(coverImageView.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(coverImageView).offset(8)
        }
        
        publishInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(publishInfoLabel.snp.bottom).offset(8)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(coverImageView)
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        likeButton.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal
        )
        categoryLabel.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
    }
    
    override func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
        
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        publishInfoLabel.font = .systemFont(ofSize: 14)
        publishInfoLabel.textColor = .darkGray
        publishInfoLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        
        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .darkGray
        categoryLabel.numberOfLines = 2

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
    
    func configure(
        content: Book,
        searchKeyword: String
    ) {
        coverImageView.setImage(with: content.cover)
        titleLabel.text = content.title
        publishInfoLabel.text = content.author + " | " + content.publisher + " | " + DateManager.shared.searchDateFormat(dateString: content.pubDate)
        priceLabel.text = content.priceStandard.formatted() + "원"
        categoryLabel.text = content.categoryName
        likeButton.isSelected = UserDefaultsManager.shared.likeBooks.contains(where: { $0.isbn13 == content.isbn13 } )
    }
    
    func configureHighlightTitle(
        _ text: String,
        searchKeyword: String
    ) {
        let highlightRange = (text as NSString).range(
            of: searchKeyword,
            options: .caseInsensitive
        )
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.systemBlue,
            range: highlightRange
        )
        titleLabel.attributedText = attributedString
    }
}
