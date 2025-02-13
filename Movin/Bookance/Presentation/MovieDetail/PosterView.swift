//
//  PosterView.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

final class PosterView: BaseView {
    private let headerLabel = UILabel()
    private let emptyLabel = UILabel()
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    override func configureHierarchy() {
        [
            headerLabel,
            collectionView,
            emptyLabel
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "Poster"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        emptyLabel.text = "포스터가 없습니다"
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .darkGray
        emptyLabel.isHidden = true
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
    
    func showEmptyView() {
        emptyLabel.isHidden = false
        collectionView.isHidden = true
    }
}
