//
//  BaseCollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ViewConfiguration, ReusableIdentifier {
    static var identifier: String { String(describing: self) }
    
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
