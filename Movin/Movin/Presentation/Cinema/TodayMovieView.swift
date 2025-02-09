//
//  TodayMovieView.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

final class TodayMovieView: BaseView {
    private let headerLabel = UILabel()
    lazy var movieCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    override func configureHierarchy() {
        [
            headerLabel,
            movieCollectionView
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        headerLabel.text = "오늘의 영화"
        headerLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        headerLabel.textColor = .movinLabel
        
        movieCollectionView.backgroundColor = .movinBackground
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.register(
            TodayMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier
        )
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 16,
            right: 16
        )
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func refreshView() {
        movieCollectionView.reloadData()
    }
}
