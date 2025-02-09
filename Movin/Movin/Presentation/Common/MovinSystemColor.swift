//
//  MovinSystemColor.swift
//  Movin
//
//  Created by 조성민 on 2/10/25.
//

import UIKit

enum MovinSystemColor {
    case primary
    case background
    case darkGray
    case label
    case alert
}

extension MovinSystemColor {
    var value: UIColor {
        switch self {
        case .primary:
            return .movinPrimary
        case .background:
            return .movinBackground
        case .darkGray:
            return .movinDarkGray
        case .label:
            return .movinLabel
        case .alert:
            return .movinAlert
        }
    }
}
