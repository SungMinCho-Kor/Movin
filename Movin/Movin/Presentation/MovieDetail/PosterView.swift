//
//  PosterView.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

final class PosterView: BaseView {
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
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "Poster"
        headerLabel.textColor = .movinWhite
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .movinBlack
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        layout.scrollDirection = .horizontal
        return layout
    }
}
