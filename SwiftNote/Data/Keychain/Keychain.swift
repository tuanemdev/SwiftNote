//
//  Keychain.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 20/03/2023.
//

import Foundation

class Keychain {
    
    static let serviceName: String = Bundle.main.bundleIdentifier!
    // MARK: - Singleton
    static let standard = Keychain()
    private init() {}
    
    // MARK: - Generic
    @discardableResult
    func save<T: Codable>(_ item: T?, service: String = Keychain.serviceName, account: String) -> Bool {
        guard let item = item else {
            return delete(service: service, account: account)
        }
        
        do {
            let data = try JSONEncoder().encode(item)
            return save(data, service: service, account: account)
        } catch {
            assertionFailure("Keychain: Fail to encode item with error: \(error)")
            return false
        }
    }
    
    func read<T: Codable>(service: String = Keychain.serviceName, account: String) -> T? {
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            assertionFailure("Keychain: Fail to decode item with error: \(error)")
            return nil
        }
    }
    
    func readAllValues(service: String = Keychain.serviceName) -> [[String: String]]? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecReturnAttributes: true,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitAll
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess,
              let result = result as? [NSDictionary] else {
            return nil
        }
        
        var allValues: [[String: String]] = .init()
        result.forEach { dict in
            guard let key = dict[kSecAttrAccount] as? String,
                  let valueData = dict[kSecValueData] as? Data,
                  let value = String(data: valueData, encoding: .utf8) else { return }
            allValues.append([key: value])
        }
        
        return allValues
    }
    
    @discardableResult
    func deleteAllValues(service: String = Keychain.serviceName) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
    
    // MARK: - CREATE
    @discardableResult
    private func save(_ data: Data, service: String, account: String) -> Bool {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        // MARK: - UPDATE
        // Item already exist, thus update it.
        if status == errSecDuplicateItem {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            let status = SecItemUpdate(query, attributesToUpdate)
            return status == errSecSuccess
        }
        
        return status == errSecSuccess
    }
    
    // MARK: - READ
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
    
    // MARK: - DELETE
    @discardableResult
    private func delete(service: String, account: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}

// MARK: - Example
/*
 CREATE:
 Keychain.standard.save(["name": "Nguyen Tuan Anh"], account: "iOS Developer")

 READ:
 let devInfo: [String: String]? = Keychain.standard.read(account: "iOS Developer")
 
 UPDATE:
 Keychain.standard.save(["name": "Anonymous"], account: "iOS Developer")
 
 DELETE:
 Keychain.standard.save(Optional<[String: String]>.none, account: "iOS Developer")
 */
