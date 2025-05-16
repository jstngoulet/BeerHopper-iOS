//
//  AuthAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation

/// A utility class responsible for handling authentication-related API operations,
/// including user login and registration for the BeerHopper application.
final class AuthAPI: NSObject {
    
    /// Sends a login request to the BeerHopper API using the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - env: The target API environment (defaults to the current environment).
    /// - Returns: A `LoginResult` object containing success status and token information.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    class func login(
        email: String,
        password: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> LoginResult {
        
        do {
            //  Fetch from the API
            guard let responseData = try await RESTClient.perform(
                LoginRequest(
                    email: email,
                    password: password
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            //  Parse the result
            let result = try JSONDecoder().decode(
                LoginResult.self,
                from: responseData
            )
            
            //  Update the rest client with the token
            //  - Note: Removes if login failed
            RESTClient.set(
                token: RESTClient.Token(from: result)
            )
            
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Sends a registration request to the BeerHopper API to create a new user account.
    /// - Parameters:
    ///   - email: The email address to register.
    ///   - password: The password for the new account.
    ///   - env: The target API environment (defaults to the current environment).
    /// - Returns: A `RegistrationResult` object indicating the outcome of the request.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    class func register(
        email: String,
        password: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> RegistrationResult {
        
        do {
            guard let responseData = try await RESTClient.perform(
                RegistrationRequest(
                    email: email,
                    password: password
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try JSONDecoder().decode(
                RegistrationResult.self,
                from: responseData
            )
            
            return result
            
        } catch {
            throw error
        }
        
    }
    
}
