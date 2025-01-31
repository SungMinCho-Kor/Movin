//
//  BackdropView.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

final class BackdropView: BaseView {
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    private let pageControlView = UIView()
    let pageControl = UIPageControl()
    //TODO: 아래와 같은 뷰는 재사용하지 않는데 커스텀 뷰로 빼는 것이 좋을까?..
    private let infoStackView = UIStackView()
    private let dateImageView = UIImageView(image: UIImage(systemName: "calendar"))
    private let rateImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let genreImageView = UIImageView(image: UIImage(systemName: "film.fill"))
    private let dateLabel = UILabel()
    private let rateLabel = UILabel()
    private let genreLabel = UILabel()
    private let firstDivider = UIView()
    private let secondDivider = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageControlView.layer.cornerRadius = pageControlView.bounds.height / 2
    }
    
    override func configureHierarchy() {
        [
            collectionView,
            infoStackView,
            pageControlView,
            pageControl
        ].forEach(addSubview)
        [
            dateImageView,
            dateLabel,
            firstDivider,
            rateImageView,
            rateLabel,
            secondDivider,
            genreImageView,
            genreLabel
        ].forEach(infoStackView.addArrangedSubview)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(280)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView).inset(16)
            make.centerX.equalTo(collectionView)
        }
        
        pageControlView.snp.makeConstraints { make in
            make.edges.equalTo(pageControl).inset(-8)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        [
            dateImageView,
            rateImageView,
            genreImageView
        ].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(16)
            }
        }
        [
            firstDivider,
            secondDivider
        ].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.verticalEdges.equalToSuperview().inset(2)
            }
        }
    }
    
    override func configureViews() {
        [
            dateImageView,
            rateImageView,
            genreImageView
        ].forEach {
            $0.tintColor = .movinDarkGray
        }
        [
            dateLabel,
            rateLabel,
            genreLabel
        ].forEach {
            $0.textColor = .movinDarkGray
            $0.font = .systemFont(ofSize: 14)
        }
        
        firstDivider.backgroundColor = .movinDarkGray
        secondDivider.backgroundColor = .movinDarkGray
        
        infoStackView.spacing = 8
        infoStackView.alignment = .center
        
        collectionView.register(
            BackdropCollectionViewCell.self,
            forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier
        )
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .movinBlack
        
        pageControl.backgroundStyle = .minimal
        pageControlView.backgroundColor = .movinDarkGray.withAlphaComponent(0.6)
        pageControlView.clipsToBounds = true
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
    
    //TODO: init으로 내용을 채우는 것과 configure로 채우는 것의 고민
    func configure(
        dateString: String,
        rate: Double,
        genreList: [Genre]
    ) {
        dateLabel.text = dateString
        rateLabel.text = "\(rate)"
        genreLabel.text = genreList.map { $0.name }.joined(separator: ", ")
    }
}
