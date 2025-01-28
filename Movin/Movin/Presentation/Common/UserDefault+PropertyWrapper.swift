//
//  UserDefault+PropertyWrapper.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    init(
        key: String,
        defaultValue: T
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: key
            )
        }
    }
}
