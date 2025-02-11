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
    private(set) var searchResult: [SearchResult] = []
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
            } else {
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
            if indexPaths.last?.row == searchResult.count - 1, !isPagingationEnd {
                page += 1
                APIService.shared.request(
                    api: DefaultRouter.search(
                        dto: SearchRequestDTO(
                            query: searchKeyword,
                            page: page
                        )
                    )
                ) { [weak self] (result: Result<SearchResponseDTO, NetworkError>) in
                    switch result {
                    case .success(let value):
                        if value.total_pages == value.page {
                            self?.isPagingationEnd = true
                        }
                        self?.searchResult.append(contentsOf: value.results)
                        output.reloadSearchResult.value = ()
                    case .failure(let error):
                        dump(error)
                        output.showErrorAlert.value = error
                    }
                }
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
            api: DefaultRouter.search(
                dto: SearchRequestDTO(
                    query: text,
                    page: page
                )
            )
        ) { [weak self] (result: Result<SearchResponseDTO, NetworkError>) in
            switch result {
            case .success(let value):
                if value.total_pages == value.page {
                    self?.isPagingationEnd = true
                }
                self?.searchResult = value.results
                output.reloadSearchResult.value = ()
                if !value.results.isEmpty {
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
}
