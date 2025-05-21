//
//  AuthAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import Foundation
import Models

/// A utility class responsible for handling authentication-related API operations,
/// including user login and registration for the BeerHopper application.
public
final class AuthAPI: NSObject {
    
    public enum AuthError: LocalizedError {
        case invalidCrednentials
        case invalidToken
        case tokenRefreshFailed
        case previousAuthNotFound
    }
    
    /// Sends a login request to the BeerHopper API using the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - env: The target API environment (defaults to the current environment).
    /// - Returns: A `LoginResult` object containing success status and token information.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    public class func login(
        email: String,
        password: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> LoginResult {
        do {
            let pkce = PKCETokenGenerator()
            let authCode = try await requestLoginCode(
                email: email,
                password: password,
                codeChallenge: pkce.codeChallenge,
                env: env
            )
            
            let loginResult = try await login(
                email: email,
                password: password,
                codeVerifier: pkce.codeVerififer,
                authCode: authCode,
                env: env
            )
            
            //  Store the token
            if let idToken = loginResult.idToken,
               let refreshToken = loginResult.refreshToken,
               let expiresIn = loginResult.expiresIn {
                /// Stores the authenticated user's token securely in the Keychain.
                /// This includes the ID token, refresh token, and expiration metadata.
                TokenStore.store(
                    token: Token(
                        idToken,
                        refreshToken,
                        expiresIn
                    ),
                    key: "id_token"
                )
            }
            
            return loginResult
        } catch {
            throw error
        }
    }
    
    private class func login(
        email: String,
        password: String,
        codeVerifier: String,
        authCode: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> LoginResult {
        do {
            //  Fetch from the API
            guard let responseData = try await RESTClient.perform(
                LoginRequest(
                    email: email,
                    password: password,
                    authCode: authCode
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            //  Parse the result
            let result = try RESTClient.sharedDecoder.decode(
                LoginResult.self,
                from: responseData
            )
            
            guard result.success else {
                throw RESTClient.RESTError.other(
                    result.message ?? "Could not log in"
                )
            }
            
            //  Update the rest client with the token
            //  - Note: Removes if login failed
            if let idToken = result.idToken
                , let refreshToken = result.refreshToken
                , let expiresIn = result.expiresIn {
                RESTClient.set(
                    token: Token(
                        idToken,
                        refreshToken,
                        expiresIn
                    )
                )
            }
            
            return result
            
        } catch {
            throw error
        }
    }
    
    private class func requestLoginCode(
        email: String,
        password: String,
        codeChallenge: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> String {
        "AUTH_CODE"
    }
    
    /// Sends a registration request to the BeerHopper API to create a new user account.
    /// - Parameters:
    ///   - email: The email address to register.
    ///   - password: The password for the new account.
    ///   - env: The target API environment (defaults to the current environment).
    /// - Returns: A `RegistrationResult` object indicating the outcome of the request.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    public
    class func register(
        email: String,
        password: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> LoginResult {
        
        do {
            guard let responseData = try await RESTClient.perform(
                RegistrationRequest(
                    email: email,
                    password: password
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try RESTClient.sharedDecoder.decode(
                RegistrationResult.self,
                from: responseData
            )
            
            guard result.success else {
                throw RESTClient.RESTError.other(
                    result.message ?? "Registration Failed"
                )
            }
            
            //  Now that the user is registered,
            //  we need to åctually log them in
            return try await login(
                email: email,
                password: password,
                env: env
            )
            
        } catch {
            throw error
        }
        
    }
    
}
