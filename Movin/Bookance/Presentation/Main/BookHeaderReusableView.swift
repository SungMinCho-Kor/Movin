//
//  BookHeaderReusableView.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import UIKit

final class BookHeaderReusableView: BaseCollectionReusableView {
    let titleButton = HeaderNavigationButton()
    
    override func configureHierarchy() {
        addSubview(titleButton)
    }
    
    override func configureLayout() {
        titleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(queryType: QueryType) {
        titleButton.setTitle(queryType.headerTitle)
    }
}
