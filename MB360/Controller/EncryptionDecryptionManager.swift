//
//  EncryptionDecryptionManager.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 05/04/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

class AesEncryption {
    
    /*
    static func encrypt(_ plaintext: String) throws -> String {
        
        var key : Data = "#HyNK$iGH#^#eChN0L0gie$^pRiVa#e^".data(using: .utf8)!
        var iv : Data = "N@i^#u#egA^ReBr0".data(using: .utf8)!
        
        var randomBytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        guard status == errSecSuccess else {
            fatalError("Failed to generate random bytes: \(status)")
        }
        let salt = Data(randomBytes)

        
        let keyData = key as NSData
        let keyBytes = UnsafeRawPointer(keyData.bytes)
        let ivData = iv as NSData
        let ivBytes = UnsafeRawPointer(ivData.bytes)
        
        let plaintextData = plaintext.data(using: .utf8)!
        var saltedData = salt //NSMutableData(data: self.salt)
        
        saltedData.append(plaintextData)
        
        let encryptedData = NSMutableData(length: Int(saltedData.count) + kCCBlockSizeAES128)!
        var encryptedLength: size_t = 0
        
        let options = CCOptions(kCCOptionPKCS7Padding)
        let cryptStatus = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), options,
                                  keyBytes, keyData.length, ivBytes,
                                  saltedData.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: saltedData.count))
        }, saltedData.count,
                                  encryptedData.mutableBytes, encryptedData.length,
                                  &encryptedLength)
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "com.example.AesEncryption", code: Int(cryptStatus))
        }
        
        let encryptedBytes = encryptedData.subdata(with: NSMakeRange(0, encryptedLength))
        let encryptedBase64 = encryptedBytes.base64EncodedString()
        
        return encryptedBase64
    }
    
    
    
    func decrypt(_ ciphertext: String) throws -> String {
        
        var key : Data = "#HyNK$iGH#^#eChN0L0gie$^pRiVa#e^".data(using: .utf8)!
        var iv : Data = "N@i^#u#egA^ReBr0".data(using: .utf8)!
        
        var randomBytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        guard status == errSecSuccess else {
            fatalError("Failed to generate random bytes: \(status)")
        }
        let salt = Data(randomBytes)

        
        let keyData = key as NSData
        let keyBytes = UnsafeRawPointer(keyData.bytes)
        let ivData = iv as NSData
        let ivBytes = UnsafeRawPointer(ivData.bytes)
        print("ABC")

        let encryptedData = Data(base64Encoded: ciphertext)!
        let decryptedData = NSMutableData(length: Int(encryptedData.count) + kCCBlockSizeAES128)!
        var decryptedLength: size_t = 0
        
        let options = CCOptions(kCCOptionPKCS7Padding)
        let cryptStatus = CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), options,
                                  keyBytes, keyData.length, ivBytes,
                                  encryptedData.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: encryptedData.count))
        }, encryptedData.count,
                                  decryptedData.mutableBytes, decryptedData.length,
                                  &decryptedLength)
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "com.example.AesEncryption", code: Int(cryptStatus))
        }
        
        let decryptedBytes = decryptedData.subdata(with: NSMakeRange(0, decryptedLength))
        let saltedData = decryptedBytes as NSData
        let saltBytes = salt//UnsafeRawPointer(self.salt.bytes)
        let plaintextBytes = saltedData.bytes + salt.count
        let plaintextData = NSData(bytes: plaintextBytes, length: decryptedBytes.count - salt.count)
        
        let decryptedString = String(data: plaintextData as Data, encoding: .utf8)!
        
        return decryptedString
    }
    
    func generateRandomBytes() -> String? {

        var keyData = Data(count: 16)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    */
    
   
}
