//
//  InternalSignInButton.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//
import SwiftUI

final class InternalSignInButtonViewModel: ObservableObject {
    
    enum LoginState {
        case none
        case loading
        case failed(Error)
        case seccess(Token)
    }
    
    @Published
    var isValidated: Bool = false
    
    let result: @Sendable (Result<Token, Error>) -> Void
    
    init(
        onCompletion: @Sendable @escaping (Result<Token, Error>) -> Void
    ) {
        self.result = onCompletion
    }
    
    @discardableResult
    func validate(email: String, password: String) -> Bool {
        print("Validating")
        isValidated = validate(email: email) && validate(password: password)
        return isValidated
    }
    
    private func validate(email: String) -> Bool {
        !email.isEmpty
    }
    
    private func validate(password: String) -> Bool {
        !password.isEmpty
    }
    
    @MainActor
    func login(email: String, password: String) {
        print("Login: \(email), \(password)")
        
        Task { @MainActor in
            do {
                _ = try await AuthAPI.login(
                    email: email,
                    password: password
                )
                
                result(.success(Token("", "", 0)))
            } catch {
                result(.failure(error))
            }
        }
    }
}

public struct InternalSignInButton: View {
    
    @StateObject
    private var viewModel: InternalSignInButtonViewModel
    
    @Binding
    var email: String
    
    @Binding
    var password: String
    
    @Binding
    var isValidated: Bool
    
    public init(
        email: Binding<String>,
        password: Binding<String>,
        isValidated: Binding<Bool>,
        result: @Sendable @escaping (Result<Token, Error>) -> Void
    ) {
        self._email = email
        self._password = password
        self._isValidated = isValidated
        self._viewModel = StateObject(
            wrappedValue: InternalSignInButtonViewModel(
                onCompletion: result
            )
        )
    }
    
    public var body: some View {
        Button(action: {
            viewModel.login(email: email, password: password)
        }) {
            Image(systemName: "person.circle.fill")
        }
        .frame(width: 42, height: 42)
        .background(Color.white)
        .foregroundStyle(
            isValidated
                ? Color.black
                : Color.accentColor
        )
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 1)
        }
        .disabled(!viewModel.isValidated)
        .onChange(of: email) { newValue in
            isValidated = viewModel.validate(email: newValue, password: password)
        }
        .onChange(of: password) { newValue in
            isValidated = viewModel.validate(email: email, password: newValue)
        }
    }
}
