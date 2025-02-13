//
//  MovieDetailViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let likeButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        let setLikeButton: Observable<Bool> = Observable(false)
        let toggleLikeButton: Observable<Bool> = Observable(false)
        let configureViews: Observable<MovieDetail?> = Observable(nil)
        let backdropViewShowEmptyView: Observable<Void> = Observable(())
        let castViewShowEmptyView: Observable<Void> = Observable(())
        let posterViewShowEmptyView: Observable<Void> = Observable(())
        let refreshBackdropView: Observable<Void> = Observable(())
        let refreshCastViewShowEmptyView: Observable<Void> = Observable(())
        let refreshPosterViewShowEmptyView: Observable<Void> = Observable(())
        let setPageControl: Observable<Int> = Observable(0)
        let showErrorAlert: Observable<Void> = Observable(())
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else { return }
            output.setLikeButton.value = UserDefaultsManager.shared.likeMovies.contains(movieDetail.movieID)
            output.configureViews.value = self.movieDetail
            self.fetchData(output: output)
        }
        
        input.likeButtonTapped.bind { [weak self] _ in
            guard let self else { return }
            UserDefaultsManager.shared.toggleLikeMovie(movieID: movieDetail.movieID)
            output.toggleLikeButton.value = UserDefaultsManager.shared.likeMovies.contains(self.movieDetail.movieID)
        }
        
        return output
    }
    
    private(set) var posterImageList: [String] = []
    private(set) var backdropImageList: [String] = []
    private(set) var castList: [Cast] = []
    private let movieDetail: MovieDetail
    private var isErrorAlertShow: Bool = false
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
    
    private func fetchData(output: Output) {
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
            if self.backdropImageList.isEmpty {
                output.backdropViewShowEmptyView.value = ()
            } else {
                output.refreshBackdropView.value = ()
                output.setPageControl.value = self.backdropImageList.count
            }
            if self.castList.isEmpty {
                output.castViewShowEmptyView.value = ()
            } else {
                output.refreshCastViewShowEmptyView.value = ()
            }
            if self.posterImageList.isEmpty {
                output.posterViewShowEmptyView.value = ()
            } else {
                output.refreshPosterViewShowEmptyView.value = ()
            }
            
            if self.isErrorAlertShow {
                output.showErrorAlert.value = ()
                self.isErrorAlertShow = false
            }
        }
    }
    
    private func fetchBackdropImages(group: DispatchGroup) {
        APIService.shared.request(
            api: DefaultRouter.fetchMovieImages(movieID: movieDetail.movieID)) { [weak self] (result: Result<FetchImagesResponseDTO, NetworkError>) in
                switch result {
                case .success(let value):
                    self?.backdropImageList = value.backdrops.prefix(5).map { $0.file_path }
                    self?.posterImageList = value.posters.map { $0.file_path }
                case .failure(let error):
                    dump(error)
                    self?.isErrorAlertShow = true
                }
                group.leave()
            }
    }
    
    private func fetchCastList(group: DispatchGroup) {
        APIService.shared.request(
            api: DefaultRouter.fetchCast(movieID: movieDetail.movieID)) { [weak self] (result: Result<FetchCastResponseDTO, NetworkError>) in
                switch result {
                case .success(let value):
                    self?.castList = value.cast
                case .failure(let error):
                    dump(error)
                    self?.isErrorAlertShow = true
                }
                group.leave()
            }
    }
    
    
}
