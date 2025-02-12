//
//  BookListViewController.swift
//  Movin
//
//  Created by 조성민 on 2/12/25.
//

import UIKit

final class BookListViewController: BaseViewController {
    private let viewModel: BookListViewModel
    private let input = BookListViewModel.Input()
    private let listTableView = UITableView()
    
    init(viewModel: BookListViewModel) {
        self.viewModel = viewModel
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
        
        output.reloadTable.bind { [weak self] _ in
            self?.listTableView.reloadData()
        }
        
        output.showErrorAlert.bind { [weak self] error in
            self?.showErrorAlert(error: error)
        }
        
        output.setNavigationTitle.bind { [weak self] title in
            self?.navigationItem.title = title
        }
        
        output.pushDetailView.bind { [weak self] isbn in
            self?.navigationController?.pushViewController(
                BookDetailViewController(isbn: isbn),
                animated: true
            )
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(listTableView)
    }
    
    override func configureLayout() {
        listTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .white
        
        listTableView.rowHeight = 200
        listTableView.separatorStyle = .singleLine
        listTableView.separatorColor = .darkGray
        listTableView.separatorInset = .zero
        listTableView.backgroundColor = .clear
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.prefetchDataSource = self
        listTableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: SearchTableViewCell.identifier
        )
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        input.likeButtonTapped.value = sender.tag
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
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
            content: viewModel.bookList[indexPath.row]
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
        didSelectRowAt indexPath: IndexPath
    ) {
        input.cellDidSelected.value = indexPath.row
    }
    
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath]
    ) {
        input.loadBookList.value = indexPaths
    }
}
