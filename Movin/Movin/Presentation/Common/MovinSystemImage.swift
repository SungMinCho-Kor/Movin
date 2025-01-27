//
//  MovinSystemImage.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import UIKit

enum MovinSystemImage {
    case camera
    case xmark
    case heart
    case unheart
    case magnifyingglass
    case calendar
    case star
    case film
}

extension MovinSystemImage {
    var value: UIImage? {
        switch self {
        case .camera:
            UIImage(systemName: "camera.fill")
        case .xmark:
            UIImage(systemName: "xmark")
        case .heart:
            UIImage(systemName: "heart.fill")
        case .unheart:
            UIImage(systemName: "heart")
        case .magnifyingglass:
            UIImage(systemName: "magnifyingglass")
        case .calendar:
            UIImage(systemName: "calendar")
        case .star:
            UIImage(systemName: "star.fill")
        case .film:
            UIImage(systemName: "film.fill")
        }
    }
}
