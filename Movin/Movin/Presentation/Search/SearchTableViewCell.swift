//
//  SearchTableViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class SearchTableViewCell: BaseTableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let genreStackView = UIStackView()
    private let likeButton = UIButton()
    
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
        posterImageView.image = nil
        posterImageView.backgroundColor = .movinDarkGray
        titleLabel.text = ""
        dateLabel.text = ""
        genreStackView.arrangedSubviews.forEach { subview in
            genreStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        likeButton.isSelected = false
    }
    
    
    override func configureHierarchy() {
        [
            posterImageView,
            titleLabel,
            dateLabel,
            genreStackView,
            likeButton
        ].forEach(contentView.addSubview)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(16)
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(posterImageView).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        genreStackView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(posterImageView)
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        backgroundColor = .movinBlack
        selectionStyle = .none
        
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .movinDarkGray
        
        genreStackView.spacing = 4
        genreStackView.distribution = .equalSpacing
        
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
    
    func configure(content: SearchResult) {
        if let posterPath = content.poster_path {
            posterImageView.backgroundColor = .clear
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.setImage(with: Environment.imageBaseURL.value + "/w500" + posterPath)
        } else {
            posterImageView.backgroundColor = .movinDarkGray
            posterImageView.image = UIImage(systemName: "xmark.octagon.fill")
            posterImageView.tintColor = .movinBlack
            posterImageView.contentMode = .center
        }
        titleLabel.text = content.title
        if !content.release_date.isEmpty {
            dateLabel.text = DateManager.shared.searchDateFormat(dateString: content.release_date)
        }
        content.genre_ids.forEach { genreID in
            guard let genre = Genre(rawValue: genreID) else {
                print(#function, "Genre Rawvalue Wrong")
                return
            }
            let label = GenreLabel()
            label.text = genre.name
            genreStackView.addArrangedSubview(label)
        }
        likeButton.isSelected = UserDefaultsManager.shared.likeMovies.contains(content.id)
    }
}
