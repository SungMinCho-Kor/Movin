//
//  PosterCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configure(image: String) {
        imageView.setImage(with: Environment.imageBaseURL.value + "/w500" + image)
    }
}
