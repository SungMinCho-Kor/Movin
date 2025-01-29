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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.width / 2
    }
    
    private func configure() {
        clipsToBounds = true
        layer.borderColor = UIColor.movinDarkGray.cgColor
        layer.borderWidth = 1
    }
    
    func changeSelection(to isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = UIColor.movinPrimary.cgColor
        } else {
            layer.borderColor = UIColor.movinDarkGray.cgColor
            layer.borderWidth = 1
        }
    }
}
