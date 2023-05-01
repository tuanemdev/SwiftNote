//
//  AccessTokenManager.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 01/05/2023.
//

import Foundation

protocol AccessTokenManagerProtocol {
    func isTokenValid() -> Bool
    func fetchToken() -> String
    func refreshWith(apiToken: APIToken) throws
}

class AccessTokenManager {
    private let userDefaults: UserDefaults
    private var accessToken: String?
    private var expiresAt = Date()
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        update()
    }
}

// MARK: - AccessTokenManagerProtocol
extension AccessTokenManager: AccessTokenManagerProtocol {
    func isTokenValid() -> Bool {
        update()
        return accessToken != nil && expiresAt.compare(Date()) == .orderedDescending
    }
    
    func fetchToken() -> String {
        return accessToken ?? ""
    }
    
    func refreshWith(apiToken: APIToken) throws {
        save(token: apiToken)
        self.accessToken = apiToken.bearerAccessToken
        self.expiresAt = apiToken.expiresAt
    }
}

// MARK: - Token Expiration
private extension AccessTokenManager {
    func update() {
        accessToken = getToken()
        expiresAt = getExpirationDate()
    }
    
    func save(token: APIToken) {
        userDefaults.set(token.bearerAccessToken, forKey: AppUserDefaultsKeys.bearerAccessToken)
        userDefaults.set(token.expiresAt.timeIntervalSince1970, forKey: AppUserDefaultsKeys.expiresAt)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: AppUserDefaultsKeys.bearerAccessToken)
    }
    
    func getExpirationDate() -> Date {
        Date(timeIntervalSince1970: userDefaults.double(forKey: AppUserDefaultsKeys.expiresAt))
    }
}

enum AppUserDefaultsKeys {
    static let bearerAccessToken = "bearerAccessToken"
    static let expiresAt = "expiresAt"
}
