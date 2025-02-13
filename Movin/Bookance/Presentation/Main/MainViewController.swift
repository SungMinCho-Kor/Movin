//
//  MainViewController.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

import UIKit

final class MainViewController: BaseViewController {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private let viewModel = MainViewModel()
    private let input = MainViewModel.Input()
    
    override init() {
        super.init()
        
        print(#function, UIScreen.main.bounds)
    }
    
    override func loadView() {
        print(#function, UIScreen.main.bounds)
        super.loadView()
        print(#function, UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        input.viewDidLoad.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        navigationItem.title = "BOOKANCE"
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(
                    image: UIImage(systemName: "magnifyingglass"),
                    style: .plain,
                    target: self,
                    action: #selector(searchButtonTapped)
                )
            ],
            animated: true
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            BookCollectionViewCell.self,
            forCellWithReuseIdentifier: BookCollectionViewCell.identifier
        )
        collectionView.register(
            BookHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookHeaderReusableView.identifier
        )
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.fetchList.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        output.pushDetailView.bind { [weak self] isbn in
            self?.navigationController?.pushViewController(
                BookDetailViewController(isbn: isbn),
                animated: true
            )
        }
        
        output.pushListView.bind { [weak self] type in
            guard let type else { return }
            self?.navigationController?.pushViewController(
                BookListViewController(viewModel: BookListViewModel(type: type)),
                animated: true
            )
        }
    }
    
    @objc private func searchButtonTapped() {
        navigationController?.pushViewController(
            SearchViewController(viewModel: SearchViewModel()),
            animated: true
        )
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] section, _ in
                
                switch section {
                case 0:
                    return self?.createNewSpecialSection()
                default:
                    return self?.createListSection()
                }
            },
            configuration: configuration
        )
        
        return layout
    }
    
    private func createNewSpecialSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(520)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(520)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
      
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        
        return section
    }
    
    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(400)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
      
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    @objc private func headerTapped(_ sender: UIButton) {
        input.headerTapped.value = sender.tag
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return QueryType.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let queryType = QueryType.allCases[section]
        guard let count = viewModel.bookList[queryType]?.count else {
            print(#function, "No Book List")
            return 0
        }
        
        return count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookHeaderReusableView.identifier,
            for: indexPath
        ) as? BookHeaderReusableView else {
            print(#function, "BookHeaderReusableView Wrong")
            return UICollectionReusableView()
        }
        if let queryType = QueryType(rawValue: indexPath.section) {
            header.configure(queryType: queryType)
            header.titleButton.tag = queryType.rawValue
            header.titleButton.addTarget(
                self,
                action: #selector(headerTapped),
                for: .touchUpInside
            )
        }
        
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let queryType = QueryType.allCases[indexPath.section]
        guard let book = viewModel.bookList[queryType]?[indexPath.row] else {
            print(#function, "NoBook")
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookCollectionViewCell.identifier,
                for: indexPath
            ) as? BookCollectionViewCell else {
                print(#function, "BookCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(content: book)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookCollectionViewCell.identifier,
                for: indexPath
            ) as? BookCollectionViewCell else {
                print(#function, "BookCollectionViewCell Wrong")
                return UICollectionViewCell()
            }
            cell.configure(content: book)
            
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        input.selectCell.value = indexPath
    }
}
