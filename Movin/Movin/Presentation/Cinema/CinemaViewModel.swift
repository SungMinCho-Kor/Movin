//
//  CinemaViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

final class CinemaViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let likeButtonTapped: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        let fetchTodayList: Observable<Void> = Observable(())
        let refreshProfileView: Observable<Void> = Observable(())
        let showErrorAlert: Observable<NetworkError?> = Observable(nil)
    }
    
    private(set) var todayMovieList: [TodayMovie] = []
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            APIService.shared.request(
                api: DefaultRouter.fetchTodayMovie) { [weak self] (result: Result<FetchTodayMovieResponseDTO, NetworkError>) in
                    switch result {
                    case .success(let value):
                        self?.todayMovieList = value.results
                        output.fetchTodayList.value = ()
                    case .failure(let error):
                        dump(error)
                        output.showErrorAlert.value = error
                    }
                }
        }
        
        input.likeButtonTapped.bind { [weak self] index in
            guard let index,
                  let id = self?.todayMovieList[index].id else { return }
            UserDefaultsManager.shared.toggleLikeMovie(movieID: id)
            output.refreshProfileView.value = ()
        }
        
        return output
    }
}
