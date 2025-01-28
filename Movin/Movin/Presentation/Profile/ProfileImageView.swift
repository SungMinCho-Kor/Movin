//
//  ProfileImageView.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

final class ProfileImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 50
        layer.borderWidth = 3
        layer.borderColor = UIColor.movinPrimary.cgColor
        clipsToBounds = true
    }
}
