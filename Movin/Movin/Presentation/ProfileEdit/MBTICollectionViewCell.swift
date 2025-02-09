//
//  MBTICollectionViewCell.swift
//  Movin
//
//  Created by 조성민 on 2/8/25.
//

import UIKit
import SnapKit

final class MBTICollectionViewCellViewModel: ViewModel {
    struct Input {
        let configure: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        let setTitle: Observable<String?> = Observable(nil)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.configure.bind { index in
            guard let index else { return }
            if let element = MBTIElement.EI(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTIElement.SN(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTIElement.TF(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTIElement.JP(rawValue: index) {
                output.setTitle.value = element.title
            } else {
                output.setTitle.value = nil
            }
        }
        
        return output
    }
}

final class MBTICollectionViewCell: BaseCollectionViewCell {
    private let viewModel = MBTICollectionViewCellViewModel()
    private let titleLabel = UILabel()
    
    private let input = MBTICollectionViewCellViewModel.Input()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = isSelected ? 0 : 1
        layer.borderColor = UIColor.movinDarkGray.cgColor
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureViews() {
        backgroundColor = .movinWhite
        
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        titleLabel.textColor = .movinDarkGray
        
        clipsToBounds = true
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.setTitle.bind { [weak self] title in
            self?.titleLabel.text = title?.uppercased()
        }
    }
    
    func configure(index: Int) {
        input.configure.value = index
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .movinPrimary : .movinWhite
            titleLabel.textColor = isSelected ? .movinWhite : .movinDarkGray
            layer.borderWidth = isSelected ? 0 : 1
        }
    }
}
