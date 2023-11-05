//
//  user.swift
//  test19
//
//  Created by Lika Nozadze on 11/5/23.
//

import Foundation


class UserDefaultsManager {
    private static let isFirstTimeLoginKey = "isFirstTimeLogin"

    static func setFirstTimeLogin(_ isFirstTimeLogin: Bool) {
        UserDefaults.standard.set(isFirstTimeLogin, forKey: isFirstTimeLoginKey)
    }

    static func isFirstTimeLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: isFirstTimeLoginKey)
    }
}
