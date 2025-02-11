//
//  SearchViewController.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    private let viewModel: SearchViewModel
    private let input = SearchViewModel.Input()
    
    private let searchBar = UISearchBar()
    private let searchResultTableView = UITableView()
    private let emptyResultLabel = UILabel()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchResultTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        input.viewDidLoad.value = ()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.becomeFirstResponder.bind { [weak self] _ in
            self?.searchBar.searchTextField.becomeFirstResponder()
        }
        
        output.reloadSearchResult.bind { [weak self] _ in
            self?.searchResultTableView.reloadData()
        }
        
        output.scrollToTop.bind { [weak self] _ in
            self?.searchResultTableView.scrollToRow(
                at: IndexPath(
                    row: 0,
                    section: 0
                ),
                at: .top,
                animated: false
            )
        }
        
        output.showErrorAlert.bind { [weak self] error in
            self?.showErrorAlert(error: error)
        }
        
        output.fillSearchTextField.bind { [weak self] text in
            self?.searchBar.text = text
        }
        
        output.isShowEmptyView.bind { [weak self] isShow in
            self?.emptyResultLabel.isHidden = !isShow
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
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = attributedString
        searchBar.searchTextField.leftView?.tintColor = .darkGray
        searchBar.delegate = self
        
        searchResultTableView.backgroundColor = .clear
        searchResultTableView.keyboardDismissMode = .onDrag
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.prefetchDataSource = self
        searchResultTableView.rowHeight = 160
        searchResultTableView.separatorStyle = .singleLine
        searchResultTableView.separatorColor = .darkGray
        searchResultTableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        
        emptyResultLabel.isHidden = true
        emptyResultLabel.textAlignment = .center
        emptyResultLabel.text = "원하는 검색결과를 찾지 못했습니다."
        emptyResultLabel.textColor = .darkGray
        emptyResultLabel.font = .systemFont(
            ofSize: 14,
            weight: .light
        )
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        input.searchButtonTapped.value = searchBar.text
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.searchResult.count
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
            content: viewModel.searchResult[indexPath.row],
            searchKeyword: viewModel.searchKeyword
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
        input.prefetch.value = indexPaths
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let detailViewController = MovieDetailViewController(
            movieDetail: MovieDetail(
                movieID: viewModel.searchResult[indexPath.row].id,
                dateString: viewModel.searchResult[indexPath.row].release_date,
                rate: viewModel.searchResult[indexPath.row].vote_average,
                genreList: viewModel.searchResult[indexPath.row].genre_ids?.prefix(2).compactMap { Genre(rawValue: $0) } ?? [],
                overview: viewModel.searchResult[indexPath.row].overview
            )
        )
        detailViewController.navigationItem.title = viewModel.searchResult[indexPath.row].title
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        UserDefaultsManager.shared.toggleLikeMovie(movieID: viewModel.searchResult[sender.tag].id)
    }
}
