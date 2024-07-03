////
////  KeychainHelper.swift
////  Namaa
////
////  Created by Afrah Saleh on 27/10/1445 AH.
////
//
//import Foundation
//import Security
//
//
//class KeychainHelper {
//
//    static func savePasscode(passcode: String, account: String) throws {
//        let query = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: account,
//            kSecValueData as String: Data(passcode.utf8)
//        ] as [String : Any]
//
//        SecItemDelete(query as CFDictionary) // Remove any existing item
//        let status = SecItemAdd(query as CFDictionary, nil)
//        guard status == errSecSuccess else {
//            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
//        }
//    }
//
//    static func getPasscode(account: String) -> String? {
//        let query = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: account,
//            kSecReturnData as String: kCFBooleanTrue!,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ] as [String : Any]
//
//        var dataTypeRef: AnyObject? = nil
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//        
//        if status == errSecSuccess {
//            if let retrievedData = dataTypeRef as? Data,
//               let passcode = String(data: retrievedData, encoding: .utf8) {
//                return passcode
//            }
//        }
//        return nil
//    }
//    
//    static func deletePasscode(account: String) throws {
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrAccount as String: account
//            ]
//            
//            let status = SecItemCopyMatching(query as CFDictionary, nil)
//            
//            switch status {
//            case errSecSuccess:
//                let deleteStatus = SecItemDelete(query as CFDictionary)
//                if deleteStatus != errSecSuccess {
//                    print("Failed to delete passcode for account: \(account)")
//                    throw NSError(domain: NSOSStatusErrorDomain, code: Int(deleteStatus), userInfo: nil)
//                } else {
//                    print("Passcode successfully deleted for account: \(account)")
//                }
//            case errSecItemNotFound:
//                print("No passcode to delete for account: \(account)")
//            default:
//                print("Error checking passcode existence for account: \(account), OSStatus: \(status)")
//                throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
//            }
//        }
//    
//    static func checkPasscodeExists(account: String) -> Bool {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: account,
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecReturnAttributes as String: true
//        ]
//        
//        let status = SecItemCopyMatching(query as CFDictionary, nil)
//        return status == errSecSuccess
//    }
//   
//}
