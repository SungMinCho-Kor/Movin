//
//  MainViewModel.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

import Foundation

final class MainViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void> = Observable(())
        let selectCell: Observable<IndexPath?> = Observable(nil)
        let headerTapped: Observable<Int> = Observable(0)
    }
    
    struct Output {
        let fetchList: Observable<Void> = Observable(())
        let presentErrorAlert: Observable<NetworkError?> = Observable(nil)
        let pushDetailView: Observable<String> = Observable("")
        let pushListView: Observable<QueryType?> = Observable(nil)
    }
    
    private(set) var bookList: [QueryType: [Book]] = [:]
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad.bind { [weak self] _ in
            self?.fetchAllList(output: output)
        }
        
        input.selectCell.bind { [weak self] indexPath in
            guard let indexPath,
                  let queryType = QueryType(rawValue: indexPath.section),
                  let list = self?.bookList[queryType] else { return }
            output.pushDetailView.value = list[indexPath.row].isbn13
        }
        
        input.headerTapped.bind { idx in
            guard let queryType = QueryType(rawValue: idx) else { return }
            output.pushListView.value = queryType
        }
        
        return output
    }
    
    private func fetchAllList(output: Output) {
        let group = DispatchGroup()
        QueryType.allCases.forEach { queryType in
            group.enter()
            DispatchQueue.global().async { [weak self] in
                APIService.shared.request(
                    api: AladinRouter.fetchList(
                        dto: FetchListRequestDTO(
                            queryType: queryType,
                            start: 1,
                            maxResults: 10
                        )
                    )) { [weak self] (result: Result<FetchResponseDTO, NetworkError>) in
                        switch result {
                        case .success(let response):
                            let items = response.item.map { $0.toModel() }
                            self?.bookList[queryType] = items
                        case .failure(let error):
                            output.presentErrorAlert.value = error
                        }
                        group.leave()
                    }
            }
        }
        group.notify(queue: .main) {
            output.fetchList.value = ()
        }
    }
}
