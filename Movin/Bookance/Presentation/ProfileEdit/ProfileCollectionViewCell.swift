//
//  ProfileCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    private let imageView = ProfileImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        imageView.changeSelection(to: false)
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.changeSelection(to: isSelected)
        }
    }
}
