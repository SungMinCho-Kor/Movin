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
            if let element = MBTI.EI(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTI.SN(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTI.TF(rawValue: index) {
                output.setTitle.value = element.title
            } else if let element = MBTI.JP(rawValue: index) {
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
        layer.borderWidth = 1
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
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .bold
        )
        titleLabel.isUserInteractionEnabled = true
        
        clipsToBounds = true
    }
    
    private func bind() {
        let output = viewModel.transform(input: input)
        
        output.setTitle.bind { [weak self] title in
            self?.titleLabel.text = title?.uppercased()
        }
    }
    
    func configure(index: Int, isSelected: Bool) {
        input.configure.value = index
        backgroundColor = isSelected ? .movinPrimary : .movinBackground
        titleLabel.textColor = isSelected ? .movinBackground : .movinDarkGray
        layer.borderWidth = isSelected ? 0 : 1
    }
}
