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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.viewDidAppear.value = ()
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
        navigationItem.title = "검색"
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "제목이나 저자를 입력하세요"
        searchBar.delegate = self
        
        searchResultTableView.backgroundColor = .clear
        searchResultTableView.keyboardDismissMode = .onDrag
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.prefetchDataSource = self
        searchResultTableView.rowHeight = 200
        searchResultTableView.separatorStyle = .singleLine
        searchResultTableView.separatorColor = .darkGray
        searchResultTableView.separatorInset = .zero
        searchResultTableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
        
        emptyResultLabel.isHidden = true
        emptyResultLabel.textAlignment = .center
        emptyResultLabel.text = "검색결과를 찾지 못했습니다."
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
        searchBar.searchTextField.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.bookList.count
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
            content: viewModel.bookList[indexPath.row],
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
        let detailViewController = BookDetailViewController(isbn: viewModel.bookList[indexPath.row].isbn13)
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        UserDefaultsManager.shared.toggleLikeBook(book: viewModel.bookList[sender.tag])
    }
}
