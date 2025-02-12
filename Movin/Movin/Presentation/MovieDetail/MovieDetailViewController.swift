//
//  MovieDetailViewController.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

struct MovieDetail {
    let movieID: Int
    let dateString: String?
    let rate: Double?
    let genreList: [Genre]
    let overview: String
}

final class MovieDetailViewController: BaseViewController {
    private let viewModel: MovieDetailViewModel
    private let input = MovieDetailViewModel.Input()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropView = BackdropView()
    private let synopsisView = SynopsisView()
    private let castView = CastView()
    private let posterView = PosterView()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        input.viewDidLoad.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            backdropView,
            synopsisView,
            castView,
            posterView
        ].forEach(contentView.addSubview)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        backdropView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        synopsisView.snp.makeConstraints { make in
            make.top.equalTo(backdropView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        castView.snp.makeConstraints { make in
            make.top.equalTo(synopsisView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        posterView.snp.makeConstraints { make in
            make.top.equalTo(castView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 40,
            right: 0
        )
        
        backdropView.collectionView.delegate = self
        backdropView.collectionView.dataSource = self
        
        castView.collectionView.delegate = self
        castView.collectionView.dataSource = self
        
        posterView.collectionView.delegate = self
        posterView.collectionView.dataSource = self
    }
    
    @objc private func likeButtonTapped(_ sender: UIBarButtonItem) {
        input.likeButtonTapped.value = ()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.setLikeButton.bind { [weak self] isLiked in
            guard let self else { return }
            let likeButton = UIBarButtonItem(
                image: UIImage(systemName: isLiked ? "heart.fill" : "heart"),
                style: .plain,
                target: self,
                action: #selector(likeButtonTapped)
            )
            likeButton.tintColor = .systemRed
            navigationItem.setRightBarButtonItems(
                [likeButton],
                animated: true
            )
        }
        
        output.configureViews.bind { [weak self] movieDetail in
            guard let self, let movieDetail else { return }
            backdropView.configure(
                dateString: movieDetail.dateString,
                rate: movieDetail.rate,
                genreList: movieDetail.genreList
            )
            synopsisView.configure(synopsis: movieDetail.overview)
        }
        
        output.toggleLikeButton.bind { [weak self] isLiked in
            self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        }
        
        output.backdropViewShowEmptyView.bind { [weak self] in
            self?.backdropView.showEmptyView()
        }
        
        output.castViewShowEmptyView.bind { [weak self] in
            self?.castView.showEmptyView()
        }
        
        output.posterViewShowEmptyView.bind { [weak self] in
            self?.posterView.showEmptyView()
        }
        
        output.refreshBackdropView.bind { [weak self] in
            self?.backdropView.collectionView.reloadData()
        }
        
        output.refreshCastViewShowEmptyView.bind { [weak self] in
            self?.castView.collectionView.reloadData()
        }
        
        output.refreshPosterViewShowEmptyView.bind { [weak self] in
            self?.posterView.collectionView.reloadData()
        }
        
        output.setPageControl.bind { [weak self] pageCount in
            self?.backdropView.pageControl.numberOfPages = pageCount
        }
        
        output.showErrorAlert.bind { [weak self] _ in
            self?.showErrorAlert()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == backdropView.collectionView {
            return viewModel.backdropImageList.count
        } else if collectionView == castView.collectionView {
            return viewModel.castList.count
        } else if collectionView == posterView.collectionView {
            return viewModel.posterImageList.count
        } else {
            print(#function, "Cell Count Wrong")
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == backdropView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BackdropCollectionViewCell.identifier,
                for: indexPath
            ) as? BackdropCollectionViewCell else {
                print(#function, "BackdropCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(image: viewModel.backdropImageList[indexPath.row])
            
            return cell
        } else if collectionView == castView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath
            ) as? CastCollectionViewCell else {
                print(#function, "CastCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(cast: viewModel.castList[indexPath.row])
            
            return cell
        } else if collectionView == posterView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                print(#function, "PosterCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(image: viewModel.posterImageList[indexPath.row])
            
            return cell
        } else {
            print(#function, "UICollectionViewCell Wrong")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == backdropView.collectionView {
            let width = collectionView.bounds.width
            
            return CGSize(width: width, height: width * 0.7)
        } else if collectionView == castView.collectionView {
            let height = collectionView.bounds.height
            let width = collectionView.bounds.width
            return CGSize(width: width / 2 , height: height / 2 - 8)
        } else if collectionView == posterView.collectionView {
            let height = collectionView.bounds.height
            
            return CGSize(width: 100, height: height)
        }
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if collectionView == backdropView.collectionView {
            backdropView.pageControl.currentPage = indexPath.row
        }
    }
}
