//
//  MovieDetailViewController.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

import UIKit

struct MovieDetail {
    let movieID: Int
    let dateString: String
    let rate: Double
    let genreList: [Genre]
}

final class MovieDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropView = BackdropView()
    
    private var backdropImageList: [String] = []
    private let movieDetail: MovieDetail
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBackdropImages()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            backdropView
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
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        let likeButton = UIBarButtonItem(
            image: UIImage(systemName: UserDefaultsManager.shared.likeMovies.contains(movieDetail.movieID) ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(likeButtonTapped)
        )
        navigationItem.setRightBarButtonItems(
            [likeButton],
            animated: true
        )
        
        backdropView.configure(
            dateString: movieDetail.dateString,
            rate: movieDetail.rate,
            genreList: movieDetail.genreList
        )
        backdropView.collectionView.delegate = self
        backdropView.collectionView.dataSource = self
    }
    
    private func fetchBackdropImages() {
        APIService.shared.request(
            api: DefaultRouter.fetchMovieImages(movieID: movieDetail.movieID)) { [weak self] (result: FetchBackdropImagesResponseDTO) in
                self?.backdropImageList = result.backdrops.prefix(5).map { $0.file_path }
                self?.backdropView.collectionView.reloadData()
            } failureCompletion: { error in
                dump(error)
            }
    }
    
    @objc private func likeButtonTapped(_ sender: UIBarButtonItem) {
        UserDefaultsManager.shared.toggleLikeMovie(movieID: movieDetail.movieID)
        sender.image = UIImage(systemName: UserDefaultsManager.shared.likeMovies.contains(movieDetail.movieID) ? "heart.fill" : "heart")
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == backdropView.collectionView {
            return backdropImageList.count
        } else {
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
            cell.configure(image: backdropImageList[indexPath.row])
            
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
        let width = collectionView.bounds.width
        
        return CGSize(width: width, height: width * 0.7)
    }
}
