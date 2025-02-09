//
//  BorderedButton.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

//TODO: Bold Title 구현
//final class BorderedButton: UIButton {
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        configurate()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configurate() {
//        var buttonConfiguration = UIButton.Configuration.bordered()
//        buttonConfiguration.baseForegroundColor = .movinPrimary
//        buttonConfiguration.background.strokeWidth = 3
//        buttonConfiguration.background.strokeColor = .movinPrimary
//        buttonConfiguration.background.backgroundColor = .movinBlack
//        buttonConfiguration.cornerStyle = .capsule
//        self.configuration = buttonConfiguration
//    }
//}

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
        buttonConfiguration.baseForegroundColor = .movinBackground
        buttonConfiguration.baseBackgroundColor = .movinPrimary
        buttonConfiguration.cornerStyle = .capsule
        self.configuration = buttonConfiguration
    }
}
