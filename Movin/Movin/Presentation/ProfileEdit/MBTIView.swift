//
//  MBTIView.swift
//  Movin
//
//  Created by 조성민 on 2/8/25.
//

import UIKit
import SnapKit

final class MBTIView: BaseView {
    private let headerLabel = UILabel()
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    override func configureHierarchy() {
        [
            headerLabel,
            collectionView
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(headerLabel.snp.trailing).offset(52)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "MBTI"
        headerLabel.textColor = .movinWhite
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .movinBackground
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            MBTICollectionViewCell.self,
            forCellWithReuseIdentifier: MBTICollectionViewCell.identifier
        )
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
}
