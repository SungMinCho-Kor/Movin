//
//  UserDefaultsManager.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import Foundation

enum UserDefaultsKey: String {
    case isOnboardingStarted
    case nickname
    case profileImageIndex
    case signUpDate
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @UserDefault(
        key: UserDefaultsKey.isOnboardingStarted.rawValue,
        defaultValue: false
    )
    var isOnboardingStarted: Bool
    @UserDefault(
        key: UserDefaultsKey.nickname.rawValue,
        defaultValue: nil
    )
    var nickname: String?
    @UserDefault(
        key: UserDefaultsKey.profileImageIndex.rawValue,
        defaultValue: Int.random(in: 0...11)
    )
    var profileImageIndex: Int
    @UserDefault(
        key: UserDefaultsKey.signUpDate.rawValue,
        defaultValue: Date()
    )
    var signUpDate: Date
    
    private init() { }
}
