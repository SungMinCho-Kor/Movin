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
    let overview: String
}

final class MovieDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backdropView = BackdropView()
    private let synopsisView = SynopsisView()
    private let castView = CastView()
    private let posterView = PosterView()
    
    private var posterImageList: [String] = []
    private var backdropImageList: [String] = []
    private var castList: [Cast] = []
    private let movieDetail: MovieDetail
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
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
            if movieDetail.overview.isEmpty {
                make.top.equalTo(backdropView.snp.bottom).offset(16)
            } else {
                make.top.equalTo(synopsisView.snp.bottom).offset(16)
            }
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
        
        
        synopsisView.configure(synopsis: movieDetail.overview)
        if movieDetail.overview.isEmpty {
            synopsisView.isHidden = true
        }
        
        castView.collectionView.delegate = self
        castView.collectionView.dataSource = self
        
        posterView.collectionView.delegate = self
        posterView.collectionView.dataSource = self
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            self.fetchBackdropImages(group: group)
        }
        group.enter()
        DispatchQueue.global().async {
            self.fetchCastList(group: group)
        }
        group.notify(queue: .main) {
            self.backdropView.collectionView.reloadData()
            self.castView.collectionView.reloadData()
            self.posterView.collectionView.reloadData()
        }
    }
    
    private func fetchBackdropImages(group: DispatchGroup) {
        APIService.shared.request(
            api: DefaultRouter.fetchMovieImages(movieID: movieDetail.movieID)) { [weak self] (result: FetchImagesResponseDTO) in
                self?.backdropImageList = result.backdrops.prefix(5).map { $0.file_path }
                self?.posterImageList = result.posters.map { $0.file_path }
                group.leave()
            } failureCompletion: { error in
                dump(error)
            }
    }
    
    private func fetchCastList(group: DispatchGroup) {
        APIService.shared.request(
            api: DefaultRouter.fetchCast(movieID: movieDetail.movieID)) { [weak self] (result: FetchCastResponseDTO) in
                self?.castList = result.cast
                group.leave()
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
        } else if collectionView == castView.collectionView {
            return castList.count
        } else if collectionView == posterView.collectionView {
            return posterImageList.count
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
            cell.configure(image: backdropImageList[indexPath.row])
            
            return cell
        } else if collectionView == castView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath
            ) as? CastCollectionViewCell else {
                print(#function, "CastCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(cast: castList[indexPath.row])
            
            return cell
        } else if collectionView == posterView.collectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                print(#function, "PosterCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(image: posterImageList[indexPath.row])
            
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
}
