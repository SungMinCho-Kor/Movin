//
//  BaseButton.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

class BaseButton: UIButton, ViewConfiguration {
    init() {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureViews() { }
}
