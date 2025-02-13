//
//  CinemaViewController.swift
//  Movin
//
//  Created by 조성민 on 1/29/25.
//

import UIKit

final class CinemaViewController: BaseViewController {
    private let profileView = ProfileView()
    private let recentSearchView = RecentSearchView()
    private let todayMovieView = TodayMovieView()
    
    private let viewModel = CinemaViewModel()
    private let input = CinemaViewModel.Input()
    
    override init() {
        super.init()
        print(self, #function)
    }
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        input.viewDidLoad.value = ()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.fetchTodayList.bind { [weak self] _ in
            self?.todayMovieView.refreshView()
        }
        
        output.refreshProfileView.bind { [weak self] _ in
            self?.profileView.refreshView()
        }
        
        output.showErrorAlert.bind { [weak self] error in
            guard let error else { return }
            self?.showErrorAlert(error: error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.refreshView()
        recentSearchView.refreshView()
        todayMovieView.refreshView()
    }
    
    override func configureHierarchy() {
        [
            profileView,
            recentSearchView,
            todayMovieView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        todayMovieView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchView.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigationItem.title = "Movin"
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(
                    image: UIImage(systemName: "magnifyingglass"),
                    style: .plain,
                    target: self,
                    action: #selector(searchButtonTapped)
                )
            ],
            animated: true
        )
        
        profileView.profileInfoButton.addTarget(
            self,
            action: #selector(profileInfoButtonTapped),
            for: .touchUpInside
        )
        
        recentSearchView.delegate = self
        
        todayMovieView.movieCollectionView.delegate = self
        todayMovieView.movieCollectionView.dataSource = self
    }
    
    @objc private func profileInfoButtonTapped() {
        let profileEditViewController = ProfileEditViewController()
        profileEditViewController.delegate = self
        present(
            BasicNavigationController(rootViewController: profileEditViewController),
            animated: true
        )
    }
    
    @objc private func searchButtonTapped() {
        navigationController?.pushViewController(
            SearchViewController(viewModel: SearchViewModel()),
            animated: true
        )
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        input.likeButtonTapped.value = sender.tag
    }
}

extension CinemaViewController: RecentSearchViewDelegate {
    func keywordButtonTapped(tag: Int) {
        navigationController?.pushViewController(
            SearchViewController(
                viewModel: SearchViewModel(
                    searchKeyword: UserDefaultsManager.shared.searchHistory[tag]
                )
            ),
            animated: true
        )
    }
}

extension CinemaViewController: ProfileSaveDelegate {
    func reloadProfile() {
        profileView.refreshView()
    }
}

extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.todayMovieList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TodayMovieCollectionViewCell.identifier,
            for: indexPath
        ) as? TodayMovieCollectionViewCell else {
            print(#function, "TodayMovieCollectionViewCell Wrong")
            return UICollectionViewCell()
        }
        cell.configure(content: viewModel.todayMovieList[indexPath.row])
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.bounds.height - 32
        
        return CGSize(
            width: height * 0.6,
            height: height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let detailViewModel = MovieDetailViewModel(
            movieDetail: MovieDetail(
                movieID: viewModel.todayMovieList[indexPath.row].id,
                dateString: viewModel.todayMovieList[indexPath.row].release_date,
                rate: viewModel.todayMovieList[indexPath.row].vote_average,
                genreList: viewModel.todayMovieList[indexPath.row].genre_ids?.prefix(2).compactMap { Genre(rawValue: $0) } ?? [],
                overview: viewModel.todayMovieList[indexPath.row].overview
            )
        )
        let detailViewController = MovieDetailViewController(
            viewModel: detailViewModel
        )
        detailViewController.navigationItem.title = viewModel.todayMovieList[indexPath.row].title
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}
