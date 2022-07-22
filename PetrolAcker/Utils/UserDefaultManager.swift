//
//  UserDefaultManager.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 22/07/22.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    let defaults = UserDefaults(suiteName: "com.petrolacker.saved.data")
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
