//
//  UserDefaultsManager.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import Foundation

enum UserDefaultsKey: String {
    case isOnboardingStarted
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @UserDefault(
        key: UserDefaultsKey.isOnboardingStarted.rawValue,
        defaultValue: false
    )
    var isOnboardingStarted: Bool
    
    private init() { }
}
