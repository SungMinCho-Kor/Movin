//
//  HeaderNavigationButton.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import UIKit

final class HeaderNavigationButton: BaseButton {
    override init() {
        super.init()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "greaterthan")
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .black
        self.configuration = configuration
    }
    
    func setTitle(_ title: String) {
        configuration?.title = title
    }
}
