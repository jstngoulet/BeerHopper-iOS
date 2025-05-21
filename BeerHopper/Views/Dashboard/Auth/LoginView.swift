//
//  LoginView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI
import NetworkingAPI

class LoginViewModel: ObservableObject {
    
    enum LoginStatus {
        case loggedOut
        case authorizing
        case loggedIn
        case authError(Error)
    }
    
    enum LoginRoute: Hashable {
        case home
        case forgotPassword
    }
    
    @Published
    var isLoggedIn: Bool = false
    
    func forgotPassword() {
        
    }
    
    func login(with email: String, password: String) async {
        do {
            let result = try await AuthAPI.login(email: email, password: password)
            
            await MainActor.run {
                isLoggedIn = result.isLoggedIn
            }
            
            print("Result: \(result)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var isSecureTextVisible = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidated: Bool = false
    
    @Binding private var isLoggedIn: Bool
    
    init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                
                TextField("Email", text: $email)
                    .textFieldStyle(
                        EmailTextFieldStyle(
                            leftIcon: Image(systemName: "person")
                        )
                    ).textInputAutocapitalization(.never)
                
                if isSecureTextVisible {
                    SecureField("Password", text: $password)
                        .textFieldStyle(
                            EmailTextFieldStyle(
                                leftIcon: Image(systemName: "unlock")
                            )
                        )
                        .textInputAutocapitalization(.never)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity)
                } else {
                    TextField("Password", text: $password)
                        .textFieldStyle(
                            EmailTextFieldStyle(
                                leftIcon: Image(systemName: "lock")
                            )
                        )
                        .textInputAutocapitalization(.never)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    InternalSignInButton(
                        email: $email,
                        password: $password,
                        isValidated: $isValidated
                    ) { result in
                        debugPrint("Result: \(result)")
                        if case .success = result {
                            isLoggedIn = true
                        } else {
                            isLoggedIn = false
                        }
                    }
                    
                    InternalGoogleSignInButton { result in
                        print("Result: \(result)")
                    }
                }
                .padding(.vertical, 8)
                
                Button("Forgot Password") {
                    viewModel.forgotPassword()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Login") {
                    Task {
                        await viewModel.login(with: email, password: password)
                    }
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isDisabled: !isValidated
                    )
                )
                .frame(maxWidth: .infinity)
                .disabled(!isValidated)
            }
            .padding(.horizontal)
            .navigationDestination(for: LoginViewModel.LoginRoute.self) { route in
                switch route {
                case .home:
                    LazyView { SearchView() }
                case .forgotPassword:
                    LazyView { SearchView() }
                }
            }
        }
        .onChange(of: viewModel.isLoggedIn) { _, newValue in
            self.isLoggedIn = newValue
        }
    }
}




#Preview("Base Login") {
    LoginView(isLoggedIn: .constant(false))
}


#Preview("Internal Button") {
    HStack {
        InternalSignInButton(
            email: .constant("email"),
            password: .constant("password"),
            isValidated: .constant(true)
        ) { result in
            print("Result: \(result)")
        }
        
        InternalGoogleSignInButton { result in
            print("Result: \(result)")
        }
    }
}
