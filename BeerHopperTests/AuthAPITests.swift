//
//  AuthAPITests.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import XCTest
@testable import BeerHopper

final class AuthAPITests: BeerHopperTests {
    
    private lazy var email: String = "TEST-35DCC913-1EF1-46EF-8FF5-C8C160479A3C-TEST@beerhopper.me"
    let password: String = "BeerHopper123!"
    
    /// Tests successful user registration with a valid email and password.
    func test_generalRegistration_success() async throws {
        let registrationResult = try await AuthAPI.register(
            email: "TEST-\(UUID().uuidString)-TEST@beerhopper.me",
            password: password,
            env: .development
        )
        XCTAssert(
            registrationResult.success,
            registrationResult.message ?? "Unknown Failure"
        )
    }
    
    /// Tests failed registration with an empty email field.
    func test_generalRegistration_fail() async throws {
        let registrationResult = try await AuthAPI.register(
            email: "",
            password: password,
            env: .development
        )
        XCTAssert(
            !registrationResult.success,
            registrationResult.message ?? ""
        )
    }
    
    /// Tests successful login using a pre-defined valid email and password.
    func test_generalLogin_success() async throws {
        
        let authResult = try await AuthAPI.login(
            email: email,
            password: password,
            env: .development
        )
        XCTAssert(authResult.success)
    }
    
    /// Tests login failure using a non-existent email.
    func test_generalLogin_failEmail() async throws {
        let authResult = try await AuthAPI.login(
            email: ["fail_", email].joined(),
            password: password,
            env: .development
        )
        XCTAssert(!authResult.success)
    }
    
    /// Tests login failure using an incorrect password.
    func test_generalLogin_failPassword() async throws {
        let authResult = try await AuthAPI.login(
            email: email,
            password: ["-", password].joined(),
            env: .development
        )
        XCTAssert(!authResult.success)
    }
    
    /// Tests the full flow: registration, successful login, and login failures with bad credentials.
    func test_registrationAndLogin_flow() async throws {
        let email = [
            "TEST-",
            UUID().uuidString,
            "-TEST",
            "@beerhopper.me"
        ].joined()
        
        // Register
        let registrationResult = try await AuthAPI.register(
            email: email,
            password: password,
            env: .development
        )
        XCTAssertTrue(registrationResult.success, registrationResult.message ?? "Unknown registration failure")
        
        // Login success
        let loginResult = try await AuthAPI.login(
            email: email,
            password: password,
            env: .development
        )
        XCTAssertTrue(loginResult.success, "Login should succeed with correct credentials")
        
        // Login fail with wrong password
        let failPasswordResult = try await AuthAPI.login(
            email: email,
            password: password + "!",
            env: .development
        )
        XCTAssertFalse(failPasswordResult.success, "Login should fail with incorrect password")
        
        // Login fail with wrong email
        let failEmailResult = try await AuthAPI.login(
            email: "fail_\(email)",
            password: password,
            env: .development
        )
        XCTAssertFalse(failEmailResult.success, "Login should fail with incorrect email")
    }
    
    /// Tests that registration fails when the password is missing.
    func test_registration_missingPassword() async throws {
        let registrationResult = try await AuthAPI.register(
            email: "missingPassword-\(UUID().uuidString)@beerhopper.me",
            password: "",
            env: .development
        )
        XCTAssertFalse(registrationResult.success, "Registration should fail without a password")
    }
    
    /// Measures the performance of the login operation with a known account.
    func test_loginPerformance() async throws {
        measure {
            let expectaction = XCTestExpectation(description: "Login Completed")
            
            Task {
                let authResult = try await AuthAPI.login(
                    email: email,
                    password: password,
                    env: .development
                )
                XCTAssertNotNil(authResult)
                expectaction.fulfill()
            }
            
            wait(for: [expectaction], timeout: 10)
        }
    }
    
    /// Measures the performance of the registration operation using a unique email.
    func test_registrationPerformance() async throws {
        measure {
            let expectaction = XCTestExpectation(description: "Registration Completed")
            let email = [
                "TEST-",
                UUID().uuidString,
                "-TEST",
                "@beerhopper.me"
            ].joined()
            
            Task {
                
                // Register
                let registrationResult = try await AuthAPI.register(
                    email: email,
                    password: password,
                    env: .development
                )
                
                XCTAssertNotNil(registrationResult)
                expectaction.fulfill()
            }
            
            wait(for: [expectaction], timeout: 10)
        }
    }
    
}
