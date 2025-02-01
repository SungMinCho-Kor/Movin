//
//  ReusableIdentifier.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

protocol ReusableIdentifier { }

extension ReusableIdentifier {
    static var identifier: String {
        String(describing: self)
    }
}
