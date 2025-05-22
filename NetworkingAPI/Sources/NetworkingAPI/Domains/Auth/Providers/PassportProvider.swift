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

public protocol PassportProvider: AnyObject {
    
    func handleSignIn(from url: URL) async
    
    @discardableResult
    func restorePreviousSession() async throws -> Token
    
    func logout() async
    
    @discardableResult
    func handleSignInButton(
        from controller: UIViewController
    ) async throws -> Token
    
    func isLoggedIn() async -> Bool
    
    func refreshToken() async throws -> Token
}

//  Optional functions
public extension PassportProvider {
    
    func handleSignInButton(from controller: UIViewController) async throws -> Token {
        throw PassportError.notSetup
    }
    
}
