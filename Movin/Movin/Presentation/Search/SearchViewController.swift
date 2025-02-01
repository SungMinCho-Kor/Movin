//
//  SearchViewController.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    private let searchBar = UISearchBar()
    private let searchResultTableView = UITableView()
    private let emptyResultLabel = UILabel()
    private var resultList: [SearchResult] = [] {
        didSet {
            searchResultTableView.reloadData()
            emptyResultLabel.isHidden = !resultList.isEmpty
        }
    }
    private var page = 0
    private var paginationEnd = false
    private var searchKeyword = ""
    
    override init() {
        super.init()
    }
    
    init(searchKeyword: String) {
        super.init()
        self.searchBar.searchTextField.text = searchKeyword
        searchBarSearchButtonClicked(searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchKeyword.isEmpty {
            searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    override func configureHierarchy() {
        [
            searchBar,
            searchResultTableView,
            emptyResultLabel
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        emptyResultLabel.snp.makeConstraints { make in
            make.edges.equalTo(searchResultTableView)
        }
    }
    
    override func configureViews() {
        navigationItem.title = "영화 검색"
        
        let attributedString = NSMutableAttributedString(string: "영화를 검색해보세요.", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.movinDarkGray
        ])
        searchBar.searchTextField.attributedPlaceholder = attributedString
        searchBar.searchTextField.leftView?.tintColor = .movinDarkGray
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .darkGray.withAlphaComponent(0.6)
        searchBar.delegate = self
        
        searchResultTableView.backgroundColor = .clear
        searchResultTableView.keyboardDismissMode = .onDrag
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.prefetchDataSource = self
        searchResultTableView.rowHeight = 160
        searchResultTableView.separatorStyle = .singleLine
        searchResultTableView.separatorColor = .movinDarkGray
        searchResultTableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        
        emptyResultLabel.isHidden = true
        emptyResultLabel.textAlignment = .center
        emptyResultLabel.text = "원하는 검색결과를 찾지 못했습니다."
        emptyResultLabel.textColor = .movinDarkGray
        emptyResultLabel.font = .systemFont(
            ofSize: 14,
            weight: .light
        )
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print(#function, "SearchBar Text Nil")
            return
        }
        if text == searchKeyword || text.isEmpty {
            return
        }
        paginationEnd = false
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
        ) { [weak self] (result: SearchResponseDTO) in
            if result.total_pages == result.page {
                self?.paginationEnd = true
            }
            self?.resultList = result.results
        } failureCompletion: { error in
            dump(error)
        }
        if !resultList.isEmpty {
            searchResultTableView.scrollToRow(
                at: IndexPath(
                    row: 0,
                    section: 0
                ),
                at: .top,
                animated: false
            )
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return resultList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.identifier,
            for: indexPath
        ) as? SearchTableViewCell else {
            print(#function, "SearchTableViewCell Wrong")
            return UITableViewCell()
        }
        cell.configure(
            content: resultList[indexPath.row],
            searchKeyword: searchKeyword
        )
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(
            self,
            action: #selector(likeButtonTapped),
            for: .touchUpInside
        )
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath]
    ) {
        if indexPaths.last?.row == resultList.count - 1, !paginationEnd {
            page += 1
            APIService.shared.request(
                api: DefaultRouter.search(
                    dto: SearchRequestDTO(
                        query: searchKeyword,
                        page: page
                    )
                )
            ) { [weak self] (result: SearchResponseDTO) in
                if result.total_pages == result.page {
                    self?.paginationEnd = true
                }
                self?.resultList.append(contentsOf: result.results)
            } failureCompletion: { error in
                dump(error)
            }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let detailViewController = MovieDetailViewController(
            movieDetail: MovieDetail(
                movieID: resultList[indexPath.row].id,
                dateString: resultList[indexPath.row].release_date,
                rate: resultList[indexPath.row].vote_average,
                genreList: resultList[indexPath.row].genre_ids?.prefix(2).compactMap { Genre(rawValue: $0) } ?? [],
                overview: resultList[indexPath.row].overview
            )
        )
        detailViewController.navigationItem.title = resultList[indexPath.row].title
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        UserDefaultsManager.shared.toggleLikeMovie(movieID: resultList[sender.tag].id)
    }
}
