//
//  UITextField+Placeholder.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

extension UITextField {
    func setPlaceholder(_ placeholderText: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.movinDarkGray,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: attributes
        )
    }
}
