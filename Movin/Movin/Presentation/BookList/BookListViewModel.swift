//
//  BookListViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import Foundation

final class BookListViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let loadBookList: Observable<[IndexPath]> = Observable([])
        let likeButtonTapped: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        let setNavigationTitle: Observable<String> = Observable("")
        let reloadTable: Observable<Void> = Observable(())
        let showErrorAlert: Observable<NetworkError?> = Observable(nil)
    }
    
    private let type: QueryType
    private(set) var bookList: [Book] = []
    private var page: Int = 0
    private var isPaginataionEnd: Bool = false
    
    init(type: QueryType) {
        self.type = type
    }
    
    deinit {
        print(self, #function)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            self?.fetchData(output: output)
            output.setNavigationTitle.value = self?.type.headerTitle ?? ""
        }
        
        input.loadBookList.bind { [weak self] indexPaths in
            if self?.isPaginataionEnd == true {
                return
            }
            guard let count = self?.bookList.count,
                  let lastIndexPath = indexPaths.last else {
                return
            }
            print(lastIndexPath)
            if lastIndexPath.row == count - 1 {
                self?.fetchData(output: output)
            }
        }
        
        input.likeButtonTapped.bind { [weak self] index in
            guard let index, let self else {
                return
            }
            UserDefaultsManager.shared.toggleLikeBook(book: bookList[index])
        }
        
        return output
    }
    
    func fetchData(output: Output) {
        page += 1
        APIService.shared.request(
            api: AladinRouter.fetchList(
                dto: FetchListRequestDTO(
                    queryType: type,
                    start: page,
                    maxResults: 20
                )
            )) { [weak self] (result: Result<FetchResponseDTO, NetworkError>) in
                switch result {
                case .success(let dto):
                    self?.bookList.append(contentsOf: dto.item.map { $0.toModel() })
                    output.reloadTable.value = ()
                    if dto.totalResults <= self?.bookList.count ?? 0 {
                        self?.isPaginataionEnd = true
                    }
                case .failure(let error):
                    dump(error)
                    output.showErrorAlert.value = error
                    self?.isPaginataionEnd = false
                }
            }
        
    }
}
