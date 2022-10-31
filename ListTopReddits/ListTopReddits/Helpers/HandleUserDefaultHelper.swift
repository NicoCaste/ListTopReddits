//
//  HandleUserDefaultHelper.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

enum UserDefaultKey: String {
    case token
}

struct HandleUserDefaultHelper {
    
    static func getObjectFrom(key: UserDefaultKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
