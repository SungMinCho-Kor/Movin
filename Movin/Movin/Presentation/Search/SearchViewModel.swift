//
//  SearchViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

import Foundation

final class SearchViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let viewDidAppear: Observable<Void> = Observable(())
        let searchButtonTapped: Observable<String?> = Observable(nil)
        let prefetch: Observable<[IndexPath]> = Observable([])
    }
    
    struct Output {
        let reloadSearchResult: Observable<Void> = Observable(())
        let showErrorAlert: Observable<NetworkError?> = Observable(nil)
        let scrollToTop: Observable<Void> = Observable(())
        let becomeFirstResponder: Observable<Void> = Observable(())
        let fillSearchTextField: Observable<String> = Observable("")
        let isShowEmptyView: Observable<Bool> = Observable(false)
    }
    
    private(set) var searchKeyword: String
    private(set) var bookList: [Book] = []
    private var isPagingationEnd: Bool = false
    private var page: Int = 0
    
    init(searchKeyword: String = "") {
        self.searchKeyword = searchKeyword
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            guard let self else {
                print(#function, "No Self")
                return
            }
            
            if !searchKeyword.isEmpty {
                search(text: searchKeyword, output: output)
                output.fillSearchTextField.value = searchKeyword
            }
        }
        
        input.viewDidAppear.bind { [weak self] _ in
            if self?.searchKeyword.isEmpty == true {
                output.becomeFirstResponder.value = ()
            }
        }
        
        input.searchButtonTapped.bind { [weak self] text in
            guard let self, let text else { return }
            if text.isEmpty || text == searchKeyword {
                return
            }
            self.search(
                text: text,
                output: output
            )
        }
        
        input.prefetch.bind { [weak self] indexPaths in
            guard let self else {
                print(#function, "No Self")
                return
            }
            if indexPaths.last?.row == bookList.count - 1, !isPagingationEnd {
                page += 1
                prefetch(output: output)
            }
        }
        
        return output
    }
    
    private func search(text: String, output: Output) {
        isPagingationEnd = false
        page = 1
        searchKeyword = text
        UserDefaultsManager.shared.appendSearchHistory(keyword: text)
        APIService.shared.request(
            api: AladinRouter.fetchSearch(
                dto: FetchSearchRequestDTO(
                    query: text,
                    start: page,
                    maxResults: 20,
                    sort: .accuracy//TODO: 검색창에 필터 버튼 만들기
                )
            )) { [weak self] (result: Result<FetchResponseDTO, NetworkError>) in
                guard let self else {
                    print(#function, "No Self")
                    return
                }
                switch result {
                case .success(let dto):
                    bookList = dto.item.map { $0.toModel() }
                    if bookList.count >= 200 || bookList.count == dto.totalResults {
                        isPagingationEnd = false
                    }
                    output.reloadSearchResult.value = ()
                    if !bookList.isEmpty {
                        output.scrollToTop.value = ()
                        output.isShowEmptyView.value = false
                    } else {
                        output.isShowEmptyView.value = true
                    }
                case .failure(let error):
                    dump(error)
                    output.showErrorAlert.value = error
                }
            }
    }
    
    private func prefetch(output: Output) {
        APIService.shared.request(
            api: AladinRouter.fetchSearch(
                dto: FetchSearchRequestDTO(
                    query: searchKeyword,
                    start: page,
                    maxResults: 20,
                    sort: .accuracy
                )
            )) { [weak self] (result: Result<FetchResponseDTO, NetworkError>) in
                guard let self else {
                    print(#function, "No Self")
                    return
                }
                switch result {
                case .success(let dto):
                    self.bookList.append(contentsOf: dto.item.map { $0.toModel() })
                    if bookList.count >= 200 || bookList.count == dto.totalResults {
                        isPagingationEnd = true
                    }
                    output.reloadSearchResult.value = ()
                case .failure(let error):
                    dump(error)
                    output.showErrorAlert.value = error
                }
            }
        
    }
}
