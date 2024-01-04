//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Marina Kolbina on 08/01/2023.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.bearerToken.rawValue)
            guard isSuccess else { return }
        }
    }
    
    func clearToken() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
