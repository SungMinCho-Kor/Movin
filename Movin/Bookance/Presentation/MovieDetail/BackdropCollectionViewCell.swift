//
//  BackdropCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
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
    
    func configure(image: String) {
        imageView.setImage(with: Environment.imageBaseURL.value + "/w500" + image)
    }
}
