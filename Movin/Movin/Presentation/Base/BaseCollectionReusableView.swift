//
//  BaseCollectionReusableView.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView, ViewConfiguration, ReusableIdentifier {
    override init(frame: CGRect) {
        super.init(frame: frame)
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
