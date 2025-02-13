//
//  MovinProfileImage.swift
//  Movin
//
//  Created by 조성민 on 2/6/25.
//

import UIKit

enum MovinProfileImage: Int, CaseIterable {
    case profile_0 = 0
    case profile_1
    case profile_2
    case profile_3
    case profile_4
    case profile_5
    case profile_6
    case profile_7
    case profile_8
    case profile_9
    case profile_10
    case profile_11
    
    var image: UIImage? {
        return UIImage(named: "profile_\(rawValue)")
    }
}
