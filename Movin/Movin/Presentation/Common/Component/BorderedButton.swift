//
//  BorderedButton.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

final class BorderedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurate() {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseForegroundColor = .movinWhite
        buttonConfiguration.baseBackgroundColor = .movinPrimary
        buttonConfiguration.cornerStyle = .capsule
        self.configuration = buttonConfiguration
    }
    
    override func setTitle(
        _ title: String?,
        for state: UIControl.State
    ) {
        guard let title else { return }
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(
                    ofSize: 18,
                    weight: .bold
                )
            ]
        )
        setAttributedTitle(
            attributedString,
            for: state
        )
    }
}
