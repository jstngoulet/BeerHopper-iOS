//
//  PassportProvider.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//
import Foundation
import UIKit

fileprivate
enum PassportError: LocalizedError {
    case notSetup
}

protocol PassportProvider: AnyObject {
    
    static func handleSignIn(from url: URL)
    
    static func configure(_ config: AnyObject?)
    
    @discardableResult
    static func restorePreviousSession() async throws -> Token
    
    static func logout()
    
    @discardableResult
    static func handleSignInButton(
        from controller: UIViewController
    ) async throws -> Token
    
    static var isLoggedIn: Bool { get }
    
    static func refreshToken() async throws -> Token
}

//  Optional functions
extension PassportProvider {
    
    static func handleSignInButton(from controller: UIViewController) async throws -> Token {
        throw PassportError.notSetup
    }
    
    static func configure(_ config: AnyObject?) { }
    
}
