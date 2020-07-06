//
//  InputValidation.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 04/12/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum Result<T, U>: Equatable {
    case success(T)
    case failure(U)
    
    public static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (success, .success):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
typealias ValidationResult = Result<Bool, Error>

enum InputValidation {
    
    enum InputError: Error {
        case invalidLength
        case invalidFormat
        case doesNotMatch
    }
    
    case none
    case length(Int)
    case email
    case password
    case match(String)
    case mobileNumber
    
    func isValid(text: String) -> Single<ValidationResult> {
        switch self {
        case .none:
            return Single.just(Result.success(true))
        case .length(let len):
            return text.count >= len ? Single.just(Result.success(true)) : Single.just(Result.failure(InputError.invalidLength))
        case .email:
            let cleanText = text.lowercased()
            let emailRegEx = "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: cleanText) ? Single.just(Result.success(true)) : Single.just(Result.failure(InputError.invalidFormat))
        case .password:
            let lengthTest = text.count >= 8
            let upperCaseTest = text.reduce("") { "\($0)\($1.unicodeScalars.filter { CharacterSet.uppercaseLetters.contains($0) })" }
            let lowerCaseTest = text.reduce("") { "\($0)\($1.unicodeScalars.filter { CharacterSet.lowercaseLetters.contains($0) })" }
            let numberTest = text.reduce("") { "\($0)\($1.unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) })" }
            let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            let specialTest = text.rangeOfCharacter(from: charSet.inverted) != nil
            let allValid = lengthTest && upperCaseTest.count > 0 && lowerCaseTest.count > 0 && numberTest.count > 0 && specialTest
            return allValid ? Single.just(Result.success(true)) : Single.just(Result.failure(InputError.invalidFormat))
        case .match(let textToMatch):
            return text == textToMatch && (textToMatch.count != 0) ? Single.just(Result.success(true)) : Single.just(Result.failure(InputError.doesNotMatch))
        case .mobileNumber:
            let cleanText = text.lowercased()
            let mobileRegex = "[+639]{4}[0-9]{9}|[09]{2}[0-9]{9}"
            let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
            return  mobileTest.evaluate(with: cleanText) ? Single.just(Result.success(true)) : Single.just(Result.failure(InputError.invalidFormat))
            
        }
    }
    
}
