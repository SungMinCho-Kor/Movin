//
//  CastView.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

final class CastView: BaseView {
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
            make.height.equalTo(16)//TODO: Height 미지정시 EmptyLabel의 top에 맞게 늘어남
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
        headerLabel.text = "Cast"
        headerLabel.textColor = .movinLabel
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        
        collectionView.register(
            CastCollectionViewCell.self,
            forCellWithReuseIdentifier: CastCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .movinBackground
        
        emptyLabel.text = "캐스트가 없습니다"
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .movinDarkGray
        emptyLabel.isHidden = true
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        
        return layout
    }
    
    func showEmptyView() {
        collectionView.isHidden = true
        emptyLabel.isHidden = false
    }
}
