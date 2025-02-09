//
//  GenreLabel.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class GenreLabel: UILabel {
    private var padding = UIEdgeInsets(
        top: 2,
        left: 4,
        bottom: 2,
        right: 4
    )
    
    init() {
        super.init(frame: .zero)
        
        font = .systemFont(ofSize: 14)
        textColor = .movinBackground
        backgroundColor = .movinDarkGray.withAlphaComponent(0.7)
        layer.cornerRadius = 4
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
